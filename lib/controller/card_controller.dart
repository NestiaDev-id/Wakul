import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddCartController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<Map<String, dynamic>> cartProducts =
      <Map<String, dynamic>>[].obs;

  // Getter to dynamically retrieve the user ID
  String get userId {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.uid;
    } else {
      return "";
    }
  }

  // Fungsi untuk menambahkan produk ke keranjang
  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      // Dapatkan referensi ke koleksi 'carts' di Firestore
      CollectionReference cartsCollection =
          _firestore.collection('carts').doc(userId).collection('products');

      // Tambahkan produk ke koleksi 'products' dengan ID produk
      await cartsCollection.doc(product['productId']).set(product);

      // Tampilkan snackbar pesan sukses dengan warna hijau
      Get.snackbar(
        'Sukses',
        'Produk berhasil ditambahkan ke keranjang!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Tampilkan pesan sukses atau lakukan tindakan lain jika diperlukan
      print('Produk berhasil ditambahkan ke keranjang!');
    } catch (e) {
      // Tampilkan snackbar pesan error dengan warna merah
      Get.snackbar(
        'Error',
        'Gagal menambahkan produk ke keranjang!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Tampilkan pesan error atau lakukan tindakan lain jika diperlukan
      print('Error: $e');
    }
  }

  Future<int> getCartItemsCount() async {
    try {
      // Dapatkan referensi ke koleksi 'carts' di Firestore
      CollectionReference cartsCollection =
          _firestore.collection('carts').doc(userId).collection('products');

      // Ambil data dari koleksi carts dan hitung jumlah dokumen
      QuerySnapshot<Object?> snapshot = await cartsCollection.get();

      // Kembalikan jumlah item dalam keranjang
      return snapshot.size;
    } catch (e) {
      // Handle errors, show snackbar, etc.
      print('Error getting cart items count: $e');
      return 0;
    }
  }

  Stream<List<Map<String, dynamic>>> fetchCart() {
    try {
      // Dapatkan referensi ke koleksi 'carts' di Firestore
      CollectionReference cartsCollection =
          _firestore.collection('carts').doc(userId).collection('products');

      // Ambil data dari koleksi carts dan return stream
      return cartsCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList());
    } catch (e) {
      // Handle errors, show snackbar, etc.
      print('Error fetching cart: $e');
      return Stream.value([]);
    }
  }
}
