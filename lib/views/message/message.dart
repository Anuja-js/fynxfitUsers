import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/providers/message_provider.dart';
import 'package:intl/intl.dart';

class MessagedUsersListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(messageUsersProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profileImage),
            ),
            title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              user.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              _formatTime(user.lastMessageTime),
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // Navigate to chat screen (Implement this part)
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return DateFormat('hh:mm a').format(time);
    } else {
      return DateFormat('MMM dd').format(time);
    }
  }
}
