import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/models/message.dar.dart';

class MessageUsersNotifier extends StateNotifier<List<MessageUser>> {
  MessageUsersNotifier()
      : super([
    MessageUser(
      name: "John Doe",
      lastMessage: "Hey! How are you?",
      profileImage:
      "assets/images/im1.png",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    MessageUser(
      name: "Alice",
      lastMessage: "Let's catch up later!",
      profileImage:
      "assets/images/im1.png",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    MessageUser(
      name: "Bob",
      lastMessage: "Meeting at 3 PM?",
      profileImage:
      "assets/images/im1.png",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ]);

  void addUser(MessageUser user) {
    state = [...state, user];
  }
}

// Provider for Message Users List
final messageUsersProvider =
StateNotifierProvider<MessageUsersNotifier, List<MessageUser>>(
        (ref) => MessageUsersNotifier());
