import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/models/coach_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/call/call_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class ChatScreen extends ConsumerStatefulWidget {
  final CoachModel coach;
  final String userId;

  ChatScreen({required this.coach, required this.userId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper function to format date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    // Check if it's today
    if (isSameDay(date, now)) {
      return 'Today';
    }
    // Check if it's yesterday
    else if (isSameDay(date, yesterday)) {
      return 'Yesterday';
    } else {
      // Return the date in a readable format (e.g., "Sep 4, 2024")
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  // Helper function to check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        title: CustomText(
          text: widget.coach.name,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.call,
              color: AppThemes.darkTheme.appBarTheme.foregroundColor,
            ),
            tooltip: 'Audio Call',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio Call Pressed')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.videocam,
              color: AppThemes.darkTheme.appBarTheme.foregroundColor,
            ),
            tooltip: 'Video Call',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return UserCallScreen(callId: widget.coach.id);
              }));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video Call Pressed')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("chats")
                  .doc("${widget.userId}_${widget.coach.id}")
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isMe = message["senderId"] == _auth.currentUser!.uid;

                    DateTime timestamp =
                    (message["timestamp"] as Timestamp).toDate();
                    String displayDate = formatDate(timestamp);
                    final time = timestamp != null ? timestamp : DateTime.now();
                    final formattedTime = DateFormat('hh:mm a').format(time);
                    final formattedDate = DateFormat('yyyy-MM-dd').format(time);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display date if it's different fr.om the previous message
                        if (index == 0 ||
                            !isSameDay(
                                timestamp,
                                (snapshot.data!.docs[index - 1]["timestamp"]
                                as Timestamp)
                                    .toDate())) // Show date
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                displayDate,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  message["text"],
                                  style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Message Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    sendMessage();
                    sendPushNotification("new", _messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String chatId = "${widget.userId}_${widget.coach.id}";

    try {
      // Save the message with a 'readBy' array
      await _firestore.collection("chats").doc(chatId).collection("messages").add({
        "senderId": _auth.currentUser!.uid,
        "receiverId": widget.coach.id,
        "text": _messageController.text.trim(),
        "timestamp": FieldValue.serverTimestamp(),
        "chatId": chatId,
        "readBy": [_auth.currentUser!.uid],
      });

      // Clear the message input
      _messageController.clear();

      // Update user's chat list
      await _firestore.collection("users").doc(widget.userId).set({
        "chatIdLists": FieldValue.arrayUnion([chatId])
      }, SetOptions(merge: true));

      // Update coach's chat list
      await _firestore.collection("coaches").doc(widget.coach.id).set({
        "chatIdLists": FieldValue.arrayUnion([chatId])
      }, SetOptions(merge: true));
    } catch (e) {
      print("Failed to send message: $e");
    }
  }



  Future<void> sendPushNotification( String title, String body) async {
    // Replace with your actual JSON file path
    final serviceAccountJson = 'assets/service-account.json';
    final coach=   await _firestore.collection("coaches").doc(widget.coach.id).get();
    final serviceAccount = ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "fynxfit",
          "private_key_id": "f8fc20233e74fc91768fb67ed56f1f395b65d9de",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDMGLrr1hCqIRCN\n8Dxn743qUrT2rXnNg9RMpCfexHALtCqZb22JKKRJItqYwSrhVskqkiuuWzNX4moN\ngFuiAjCzqObSkY7bqHYRlyMsPuDFpExVJYYXZU5+pHBqv42XjhZolchtCy3Y1Cs+\nDbPlYxeq+fYXB8W3sVKwXhUS145QAPPraIs+pMx2GQTCH4+DhRSlP1jEm9yOWtkI\n32Qh/i/gICbHKZKwwrByYWsIkzd1WdqZ/ezLFFVkPQGvNJjuKR8QhGr00P1pFbAO\nRkCgu3RuZVhLVPZwWIDKbxNA7iE6aR59Wb8OS2SCZR/8FnnvSMhdq36LUdMVeK5u\nvflMTngpAgMBAAECggEAD/ZBLC+eNwgF+OvYdZJ9KV3VjFNN6t5MDMBr49a+IpQx\nHrXhva/hhVzF9ttopJ36dqte4jB8x/tLqwmmYPnF4E8t2jsLDq/SqBaHaC70ulBa\nrfAU2CCSroHizt5zTu6MXxqTxb9xkvso9J3yu1ZwI+2PqwZvFqo2GtgI0uPr2+LL\nb4Weu0c7Nd+SIeMrLKsWN5npsKdUFVA5l6XLEmRefgGrpeTJsXJ09+eBwtriHoYI\nsjnsKrgQY6qQTNt7a6XzSZ0Q5ulqlKzfAu1ySIjXFATI6gR7fVhLNu+lD8zwTcrs\nVnesIytXK+1J4eWsT796NrH4ipua6CUMxIgVeiwelwKBgQDmcNI4hws0siJh1q8p\nwn/Hi8SvlbvJT+PpMzrhlTfM73WqBiPMcMSZ8PK0OczgzicEWg97Yz56rYtauHGJ\ngqpHU6Mna692Y9lL9NmQM/QXKa3zwa3aZgulTdk1WAQTmth84zVQJh9uzdL05zqL\nfJTFhbXQk9F8Q6jIbpXU+QnzywKBgQDiu+OnAbjigUVgZKs0yiw9dPlvZFEkUY29\n+C+sq56o8jTH8exY7j9yae8XyRLbij8805eERzvdRj36ZzoeUodcneum4Uubizgp\nRcduXy/r306iNNL2Shevv0VUFep4+K7ROz5mbIfYEuWJy6KOwTq34/ZqvC7GqXUm\nei7iW7qNWwKBgCTHhQX4p9U1ST+MYFCt9m8G49GSeHJdCedCgfdXNZzD62fDqxsK\nNJbNWi9huk13GcscBLSQ1nwGDuPf5F8qN7tCohu8mDixHxF8du0JHcBEqrrpArKE\n7v7nOe/FqIDoif0E1pGARCwPNchYz4NL0wLjoG016o2Gzv2OiOOBDBGZAoGAVCKC\nnJNgBvUPSHCyszkeZ4PDl5kzHvYAUfEJx9o7WtfdzCAyouFtu8ghh8L+c2b+hlTC\nEbzZMwgAsa2ifGQFhNG5A0jw5Hwpz+7rzUIXJ0DLDhfp/KiL15RzZntncZJeVJfW\nVO2LDxwb/yEIZk6/ukMmSn8gIGn7ZdbLFQYS2KcCgYAhefDHaW52p3xKI0crfFfE\ntbKIPJnfi0uyfc+RduQm02Cuoc72K5ajXee3q6jTtN4nyZqo6KK6FvQBxrbNeKeG\nNhETqYVmowDXypmLIl8UTfNv9lI5aoqWHWN9C/hNo5JPyne0sbbUwFP9JtCmW90q\n7yIYh3FV7ZuiF6RUh/Q0Ow==\n-----END PRIVATE KEY-----\n",
          "client_email": "fcm-sender@fynxfit.iam.gserviceaccount.com",
          "client_id": "110566486742074336971",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fcm-sender%40fynxfit.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(serviceAccount, scopes);

    final projectId = 'fynxfit'; // Replace with your actual project ID

    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

    final message = {
      "message": {
        "token": coach["fcmtocken"],
        "notification": {
          "title": title,
          "body": body,
        },
        "android": {
          "priority": "HIGH",
        },
        "apns": {
          "headers": {"apns-priority": "10"},
          "payload": {
            "aps": {
              "sound": "default"
            }
          }
        }
      }
    };

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    client.close();
  }
}
