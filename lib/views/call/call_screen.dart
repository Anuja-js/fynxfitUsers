import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fynxfituser/providers/signaling_provider.dart';

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
  late final String callId;

  @override
  void initState() {
    super.initState();
    callId = FirebaseAuth.instance.currentUser!.uid +
        widget.coachId +
        DateTime.now().toIso8601String();
    _startCall();
  }

  Future<void> _startCall() async {
    final signaling = ref.read(signalingProvider);

    await signaling.initialize(isVideo: true, callId: callId);
    await signaling.makeCall(
      callId,
      receiverId: widget.coachId,
      isVideo: true,
      callerId: FirebaseAuth.instance.currentUser!.uid,
    );

    // Create call document in Firestore
    await FirebaseFirestore.instance.collection('calls').doc(callId).set({
      'callerId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.coachId,
      'isVideo': true,
      'hasJoined': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final signaling = ref.read(signalingProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Calling...")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('calls')
            .doc(callId)
            .snapshots(),
        builder: (context, snapshot) {
          final doc = snapshot.data;

          // Wait for Firestore to initialize
          if (!snapshot.hasData || !doc!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final hasJoined = doc['hasJoined'] ?? false;

          return Stack(
            children: [
              !hasJoined || signaling.remoteRenderer.srcObject == null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Waiting for coach to join...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
                  : RTCVideoView(
                signaling.remoteRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                mirror: true,
              ),
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RTCVideoView(signaling.localRenderer, mirror: true),
                ),
              ),
              Positioned(
                bottom: 30,
                left: MediaQuery.of(context).size.width * 0.4,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                  onPressed: () async {
                    await signaling.disposeResources();
                    await FirebaseFirestore.instance
                        .collection('calls')
                        .doc(callId)
                        .delete();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
