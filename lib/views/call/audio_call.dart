import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/services/firestore_service.dart';
import 'signaling.dart';

class UserAudioCallScreen extends ConsumerStatefulWidget {
  final String coachId;
  final String image;

  const UserAudioCallScreen({
    super.key,
    required this.coachId,
    required this.image,
  });

  @override
  ConsumerState<UserAudioCallScreen> createState() => _UserAudioCallScreenState();
}

class _UserAudioCallScreenState extends ConsumerState<UserAudioCallScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Signaling? signaling;
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();
    startCall(widget.coachId + user!.uid.toString(), true);
  }

  @override
  void dispose() {
    signaling?.leaveCall();
    super.dispose();
  }

  Future<void> startCall(String roomId, bool isCaller) async {
    setState(() => _status = isCaller ? 'Creating audio room...' : 'Joining audio room...');
    try {
      signaling = Signaling(
        roomId: roomId,
        audioOnly: true, // Ensure Signaling handles audio-only calls
      );
      await signaling!.init(isCaller: isCaller);
      setState(() => _status = 'In audio call');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> leaveCall() async {
    final endTime = DateTime.now();
    final duration = signaling?.startTime != null
        ? endTime.difference(signaling!.startTime!).inSeconds
        : 0;

    await signaling?.leaveCall();

    setState(() => _status = 'Call ended');

    await FirestoreService().addCallHistory(
      userId: widget.coachId,
      callData: {
        'timestamp': Timestamp.now(),
        'callWith': widget.coachId,
        'type': 'audio',
        'duration': duration,
      },
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Call'),
        backgroundColor: Colors.teal[800],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(widget.image),
              ),
              const SizedBox(height: 20),
              Text(
                'Calling ${widget.coachId}...',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Status: $_status',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FloatingActionButton(
                  //   heroTag: 'joinAudio',
                  //   backgroundColor: Colors.teal[700],
                  //   onPressed: () => startCall(widget.coachId + user!.uid.toString(), false),
                  //   child: const Icon(Icons.call),
                  // ),
                  FloatingActionButton(
                    heroTag: 'leaveAudio',
                    backgroundColor: Colors.red,
                    onPressed: leaveCall,
                    child: const Icon(Icons.call_end),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
