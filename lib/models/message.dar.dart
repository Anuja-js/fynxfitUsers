import 'package:fynxfituser/models/coach_model.dart';

class CoachChatModel extends CoachModel {
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isUnread;

  CoachChatModel({
    required super.id,
    required super.name,
    required super.profileImage,
    required super.expertise,
    this.lastMessage = '',
    this.lastMessageTime,
    this.isUnread = false, required super.bio,
    required super.experience, required super.verified,
  });
}
