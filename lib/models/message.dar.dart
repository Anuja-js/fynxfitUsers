class MessageUser {
  final String name;
  final String lastMessage;
  final String profileImage; // URL or asset path
  final DateTime lastMessageTime;

  MessageUser({
    required this.name,
    required this.lastMessage,
    required this.profileImage,
    required this.lastMessageTime,
  });
}
