import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/models/message.dar.dart';
import 'package:fynxfituser/providers/message_provider.dart';
import 'package:fynxfituser/views/message/chat_screen.dart';

class MessagedCoachesListScreen extends ConsumerWidget {
  const MessagedCoachesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageState = ref.watch(messageViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Coaches')),
      body: messageState.when(
        data: (coaches) {
          // Filter for only verified coaches
          final verifiedCoaches = coaches.where((coach) => coach.verified).toList();

          if (verifiedCoaches.isEmpty) {
            return const Center(child: Text('No verified coaches found.'));
          }

          return ListView.builder(
            itemCount: verifiedCoaches.length,
            itemBuilder: (context, index) {
              final CoachChatModel coach = verifiedCoaches[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(coach.profileImage),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                ),
                title: Text(
                  coach.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.lastMessage.isNotEmpty ? coach.lastMessage : 'No messages yet',
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coach.lastMessageTime != null
                          ? _formatTime(coach.lastMessageTime!)
                          : '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                trailing: coach.isUnread
                    ? const Icon(Icons.mark_chat_unread, color: Colors.red)
                    : const Icon(Icons.mark_chat_read, color: Colors.green),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        coach: coach,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
