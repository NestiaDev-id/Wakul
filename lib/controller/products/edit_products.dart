import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart' as s;
import 'package:image_picker/image_picker.dart';

class EditProductController {
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

  void updateProduct(
    String name,
    String description,
    int stock,
    int price,
    String image1,
    String kategori,
  ) async {
    CollectionReference products =
        firestore.collection("categories").doc(kategori).collection("products");

    try {
      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        // Create a unique filename for the image
        String fileName =
            'product_$kategori${DateTime.now().millisecondsSinceEpoch}.$ext';

        // Upload the image to Firebase Storage
        s.Reference storageReference =
            storage.ref().child('product_images').child(fileName);
        await storageReference.putFile(file);

        // Get the download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();

        // Update the product with the image URL
        image1 = imageUrl;
        print(image1);
      }

      QuerySnapshot querySnapshot = await products
          .where("idkategori", isEqualTo: kategori)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String productId = querySnapshot.docs.first.id;

        await products.doc(productId).update({
          "name": name,
          "description": description,
          "stock": stock,
          "imageUrls": image1,
          "price": price,
        });

        // Show success snackbar
        Get.snackbar(
          "Berhasil",
          "Berhasil Memperbarui produk",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.pop(Get.overlayContext!, kategori);
      } else {
        Get.snackbar(
          "Error",
          "Product tidak ditemukan",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        "Error",
        "Tidak Berhasil memperbarui product",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
