import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class DeleteProductController {
  Future<bool> deleteItemFromFirestore(
      String categoryName, String itemId) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Dapatkan referensi ke koleksi produk di dalam kategori tertentu
      CollectionReference products = FirebaseFirestore.instance
          .collection("categories")
          .doc(categoryName)
          .collection("products");

      // Hapus item berdasarkan ID
      await products.doc(itemId).delete();

      // Setelah menghapus item, kembali ke layar sebelumnya

      return true; // Item berhasil dihapus
    } catch (e) {
      print("Error deleting item: $e");
      return false; // Gagal menghapus item
    }
  }
}
