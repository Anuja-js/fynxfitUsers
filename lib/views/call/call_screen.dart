
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fynxfituser/services/firestore_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'signaling.dart';

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
  late String roomId;
  final user = FirebaseAuth.instance.currentUser;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  final _roomIdController = TextEditingController();
  Signaling? signaling;
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    startCall(widget.coachId+user!.uid.toString(), true);
  }

  @override
  void dispose() {
    signaling?.leaveCall();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  Future<void> startCall(String roomId, bool isCaller) async {
    setState(() => _status = isCaller ? 'Creating room...' : 'Joining room...');
    try {
      signaling = Signaling(
        roomId: roomId,
        localRenderer: _localRenderer,
        remoteRenderer: _remoteRenderer,
      );
      await signaling!.init(isCaller: isCaller);
      setState(() => _status = 'In call');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> leaveCall() async {
    // Get call end time
    final endTime = DateTime.now();

    // Calculate call duration if startTime is available
    final duration = signaling?.startTime != null
        ? endTime.difference(signaling!.startTime!).inSeconds
        : 0;

    // Clean up WebRTC connection
    await signaling?.leaveCall();

    setState(() => _status = 'Call ended');

    // Add call history to Firestore
    await FirestoreService().addCallHistory(
      userId: widget.coachId,
      callData: {
        'timestamp':Timestamp.now(),
        'callWith': widget.coachId, // Assuming the other user is the caller
        'type':  'video',
        'duration': duration,
      },
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        backgroundColor: Colors.teal[800],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: (){
                setState(() {

                });
              },
              child: Container(
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 16,
            width: 120,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RTCVideoView(
                  _localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TextField(
                  //   controller: _roomIdController,
                  //   style: const TextStyle(color: Colors.white),
                  //   decoration: InputDecoration(
                  //     labelText: 'Room ID',
                  //     labelStyle: const TextStyle(color: Colors.white70),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(color: Colors.white24),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.teal),
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.white10,
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Text(
                    'Status: $_status',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // FloatingActionButton(
                      //   heroTag: 'create',
                      //   backgroundColor: Colors.teal,
                      //   onPressed: () =>
                      //       startCall(_roomIdController.text.trim(), true),
                      //   child: const Icon(Icons.add),
                      // ),
                      FloatingActionButton(
                        heroTag: 'refresh',
                        backgroundColor: Colors.teal[700],
                        onPressed: () {setState(() {

                        });},
                        child: const Icon(Icons.login),
                      ),
                      FloatingActionButton(
                        heroTag: 'leave',
                        backgroundColor: Colors.red,
                        onPressed: leaveCall,
                        child: const Icon(Icons.call_end),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

