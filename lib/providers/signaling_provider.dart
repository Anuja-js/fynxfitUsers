import 'package:flutter/material.dart';

class ZegoCallController extends ChangeNotifier {
  String? roomName;
  String? userId;
  String? userName;
  String? avatarURL;

  void setCallDetails({
    required String room,
    required String uid,
    required String name,
    String? avatar,
  }) {
    roomName = room;
    userId = uid;
    userName = name;
    avatarURL = avatar;
    notifyListeners();
  }

  void leaveCall(BuildContext context) {
    Navigator.pop(context); // Assumes the call screen is on top of Navigator stack
  }
}
