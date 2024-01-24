import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UserController {
  final isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  XFile? image;
  void Function()? onImageChanged;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print(image!.name);
      print(image!.path);
    } else {
      print(image);
    }

    if (onImageChanged != null) {
      onImageChanged!();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamRole() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("users").doc(uid).snapshots();
  }

  // Stream<DocumentSnapshot<Map<String, dynamic>>> getUsername() async* {
  //   String uid = auth.currentUser!.uid;

  //   // Digunakan untuk mendelepas stream yang dikembalikan oleh firestore.collection("users").doc(uid).snapshots()
  //   yield* firestore.collection("users").doc(uid).snapshots();
  // }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDataUser() async* {
    String uid = auth.currentUser!.uid;

    // Digunakan untuk mendelepas stream yang dikembalikan oleh firestore.collection("users").doc(uid).snapshots()
    yield* firestore.collection("users").doc(uid).snapshots();
  }

  void updateProfile(
    String username,
    String email,
    String image1,
  ) async {
    String uid = auth.currentUser!.uid;

    CollectionReference users = firestore.collection("users");

    try {
      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        // Create a unique filename for the image
        String fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.$ext';

        // Upload the image to Firebase Storage
        s.Reference storageReference =
            storage.ref().child('profile_images').child(fileName);
        await storageReference.putFile(file);

        // Get the download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();

        // Update the user with the image URL
        image1 = imageUrl;
        print(image1);
      }

      // Check if the user already exists
      DocumentSnapshot<Object?> userSnapshot = await users.doc(uid).get();

      if (userSnapshot.exists) {
        // If the user exists, update the existing document
        await users.doc(uid).update({
          "username": username,
          "email": email,
          "imageUrls": image1,
        });
      } else {
        // If the user doesn't exist, create a new document
        await users.doc(uid).set({
          "username": username,
          "email": email,
          "imageUrls": image1,
        });
      }

      // Show success snackbar
      Get.snackbar(
        "Berhasil",
        "Berhasil Memperbarui profil",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Jika Anda ingin kembali ke halaman sebelumnya atau mengganti halaman, Anda bisa menambahkan kode navigasi di sini
    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        "Error",
        "Tidak Berhasil memperbarui profil",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
