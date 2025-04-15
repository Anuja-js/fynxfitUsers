import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/models/message.dar.dart';
final messageViewModelProvider = FutureProvider<List<CoachChatModel>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final currentUserId = auth.currentUser!.uid;

  final coachesSnapshot = await firestore.collection('coaches').get();

  final List<CoachChatModel> chatModels = [];

  for (var doc in coachesSnapshot.docs) {
    final coachData = doc.data();
    final chatId = "${currentUserId}_${doc.id}";

    final messagesSnapshot = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    String lastMessage = '';
    DateTime? time;
    bool isUnread = false;

    if (messagesSnapshot.docs.isNotEmpty) {
      final msgData = messagesSnapshot.docs.first.data();
      lastMessage = msgData['text']?.toString() ?? '';
      final timestamp = msgData['timestamp'];
      time = (timestamp is Timestamp) ? timestamp.toDate() : null;

      final readBy = (msgData['readBy'] as List?)?.cast<String>() ?? [];
      isUnread = !readBy.contains(currentUserId);
    }

    chatModels.add(CoachChatModel(
      id: doc.id,
      name: coachData['name']?.toString() ?? 'Unnamed Coach',
      profileImage: coachData['profileImage']?.toString() ?? '',
      expertise: coachData['expertise']?.toString() ?? 'Unknown',
      lastMessage: lastMessage,
      lastMessageTime: time,
      isUnread: isUnread, bio:coachData['bio']?.toString()??"", experience:coachData['experience']?.toString()??"", verified:coachData["verified"]??"false",
    ));
  }

  return chatModels;
});
