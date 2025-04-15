import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fynxfituser/providers/signaling_provider.dart';

class UserCallScreen extends ConsumerWidget {
  final String callId;
  const UserCallScreen({super.key, required this.callId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signaling = ref.read(signalingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("User Calling")),
      body: FutureBuilder(
        future: signaling.initialize().then((_) => signaling.makeCall(callId)),
        builder: (context, snapshot) {
          return Stack(
            children: [
              RTCVideoView(signaling.remoteRenderer),
              Positioned(
                right: 20,
                top: 20,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: RTCVideoView(signaling.localRenderer, mirror: true),
                ),
              ),
              Positioned(
                bottom: 30,
                left: MediaQuery.of(context).size.width * 0.4,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                  onPressed: () {
                    signaling.disposeResources();
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
