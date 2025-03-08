import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../core/utils/constants.dart';

class ProfileImageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<String?> uploadImageToCloudinary(File file) async {
    try {
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/image/upload");

      var request = http.MultipartRequest("POST", uri)
        ..fields['upload_preset'] = CloudinaryConstants.CLOUDINARY_UPLOAD_PRESET
        ..fields['api_key'] = CloudinaryConstants.CLOUDINARY_API_KEY
        ..files.add(await http.MultipartFile.fromPath("file", file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = json.decode(await response.stream.bytesToString());
        return responseData["secure_url"];
      } else {
        print("Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// **Save Image URL to Firestore**
  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection("users").doc(userId).update({"image": imageUrl});
  }
}


