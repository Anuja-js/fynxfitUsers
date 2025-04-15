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

  Future<void> initialize() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    localStream = await navigator.mediaDevices.getUserMedia({
      'video': {'facingMode': 'user'},
      'audio': true,
    });

    localRenderer.srcObject = localStream;

    peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
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
      _firestore.collection('calls/demoCall/candidates').add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
  }

  Future<void> makeCall(String callId) async {
    final offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    await _firestore.collection('calls').doc(callId).set({
      'offer': {
        'type': offer.type,
        'sdp': offer.sdp,
      }
    });

    _firestore.collection('calls').doc(callId).snapshots().listen((doc) async {
      final data = doc.data();
      if (data != null && data['answer'] != null) {
        final answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );
        await peerConnection!.setRemoteDescription(answer);
      }
    });

    _firestore.collection('calls/$callId/candidates').snapshots().listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        final data = doc.doc.data()!;
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        peerConnection!.addCandidate(candidate);
      }
    });
  }

  Future<void> receiveCall(String callId) async {
    final doc = await _firestore.collection('calls').doc(callId).get();
    final data = doc.data();

    final offer = RTCSessionDescription(
      data!['offer']['sdp'],
      data['offer']['type'],
    );

    await peerConnection!.setRemoteDescription(offer);

    final answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);

    await _firestore.collection('calls').doc(callId).update({
      'answer': {
        'type': answer.type,
        'sdp': answer.sdp,
      }
    });

    _firestore.collection('calls/$callId/candidates').snapshots().listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        final data = doc.doc.data()!;
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        peerConnection!.addCandidate(candidate);
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
