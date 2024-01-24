import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProductController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ImagePicker picker = ImagePicker();
  final Uuid _uuid = Uuid();

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

  void addProduct(
    String name,
    String description,
    int stock,
    String image,
    int price,
    String kategori,
  ) async {
    CollectionReference products =
        firestore.collection("categories").doc(kategori).collection("products");

    try {
      String productId = _uuid.v4();

      await products.doc(productId).set(
        {
          "idProduct": productId,
          "name": name,
          "description": description,
          "stock": stock,
          "imageUrls": image,
          "sold": 0,
          "price": price,
          "idkategori": kategori,
        },
      );

      Get.snackbar(
        "Berhasil",
        "Berhasil Menambahkan produk",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.pop(Get.overlayContext!, kategori);
    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        "Error",
        "Tidak Berhasil menambahkan product",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
