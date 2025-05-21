import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class UserCallScreen extends ConsumerStatefulWidget {
  final String coachId;
  final String image;

  const UserCallScreen({
    super.key,
    required this.coachId,
    required this.image,
  });

  @override
  ConsumerState<UserCallScreen> createState() => _UserCallScreenState();
}

class _UserCallScreenState extends ConsumerState<UserCallScreen> {
  late String userId;
  late String userName;
  late String roomId;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    setupCall();
  }

  Future<void> setupCall() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
    userName = currentUser?.displayName ?? 'User';
    roomId = generateRoomID(userId, widget.coachId);

    // Request permissions
    await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Initialize Zego
    ZegoUIKit().init(
      appID: 2141926597,
      appSign: "0e3dcf791edb2de436b05850732ece53c4b5809a0956a62fc07c302978f1d089",
    );

    // Update state
    setState(() {
      isReady = true;
    });
  }

  String generateRoomID(String id1, String id2) {
    final sorted = [id1, id2]..sort();
    return sorted.join('_');
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ZegoUIKitPrebuiltCall(
      appID: 2141926597,
      appSign: "0e3dcf791edb2de436b05850732ece53c4b5809a0956a62fc07c302978f1d089",
      userID: userId,
      userName: userName,
      callID: roomId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(

      )..layout = ZegoLayout.pictureInPicture()
        // mode: ZegoLayoutMode.pictureInPicture,
        // smallViewPosition: ZegoViewPosition.topRight,
        // smallViewSize: Size(120, 160),

        ..avatarBuilder = (context, size, user, extraInfo) {
          return CircleAvatar(
            backgroundImage: NetworkImage(widget.image),
            radius: size.width / 2,
          );
        },
    );
  }
}
