import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final signalingProvider = ChangeNotifierProvider.autoDispose(
      (ref) => SignalingController(),
);

class SignalingController extends ChangeNotifier {
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  MediaStream? localStream;
  RTCPeerConnection? peerConnection;

  final _firestore = FirebaseFirestore.instance;

  bool _remoteDescriptionSet = false;
  final List<RTCIceCandidate> _remoteCandidatesQueue = [];

  Future<void> initialize({
    required bool isVideo,
    required String callId,
  }) async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    final mediaConstraints = {
      'audio': true,
      'video': isVideo ? {'facingMode': 'user'} : false,
    };

    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    localRenderer.srcObject = localStream;

    peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });

    peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        _firestore
            .collection("calls")
            .doc(callId)
            .collection("candidates")
            .add({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };
  }

  Future<void> makeCall(
      String callId, {
        required bool isVideo,
        required String callerId,
        required String receiverId,
      }) async {
    final offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    await _firestore.collection('calls').doc(callId).set({
      'offer': {
        'type': offer.type,
        'sdp': offer.sdp,
      },
      'callerId': callerId,
      'receiverId': receiverId,
      'type': isVideo ? 'video' : 'audio',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Listen for answer
    _firestore.collection('calls').doc(callId).snapshots().listen((doc) async {
      final data = doc.data();
      if (data != null && data['answer'] != null && !_remoteDescriptionSet) {
        final answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );
        await peerConnection!.setRemoteDescription(answer);
        _remoteDescriptionSet = true;

        // Add queued ICE candidates
        for (var cand in _remoteCandidatesQueue) {
          await peerConnection!.addCandidate(cand);
        }
        _remoteCandidatesQueue.clear();
      }
    });

    // Listen for remote ICE candidates
    _firestore
        .collection("calls")
        .doc(callId)
        .collection("candidates")
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          if (data != null && data['candidate'] != null) {
            final candidate = RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            );

            if (_remoteDescriptionSet) {
              peerConnection!.addCandidate(candidate);
              print("Remote ICE candidate added directly: ${data['candidate']}");
            } else {
              _remoteCandidatesQueue.add(candidate);
              print("Remote ICE candidate queued: ${data['candidate']}");
            }
          }
        }
      }
    });
  }

  Future<void> receiveCall(String callId) async {
    final doc = await _firestore.collection('calls').doc(callId).get();
    final data = doc.data();

    if (data == null || data['offer'] == null) return;

    final offer = RTCSessionDescription(
      data['offer']['sdp'],
      data['offer']['type'],
    );

    await peerConnection!.setRemoteDescription(offer);
    _remoteDescriptionSet = true;

    // Add queued candidates if any
    for (var cand in _remoteCandidatesQueue) {
      await peerConnection!.addCandidate(cand);
    }
    _remoteCandidatesQueue.clear();

    final answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);

    await _firestore.collection('calls').doc(callId).update({
      'answer': {
        'type': answer.type,
        'sdp': answer.sdp,
      }
    });

    // Listen for ICE candidates from caller
    _firestore
        .collection("calls")
        .doc(callId)
        .collection("candidates")
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          if (data != null && data['candidate'] != null) {
            final candidate = RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            );

            if (_remoteDescriptionSet) {
              peerConnection!.addCandidate(candidate);
              print("Remote ICE candidate added directly: ${data['candidate']}");
            } else {
              _remoteCandidatesQueue.add(candidate);
              print("Remote ICE candidate queued: ${data['candidate']}");
            }
          }
        }
      }
    });
  }

  Future<void> disposeResources() async {
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    await localStream?.dispose();
    await peerConnection?.close();
  }
}
