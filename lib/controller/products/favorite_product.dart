import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class FavoriteController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> getUserId() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        // Jika tidak ada pengguna yang masuk, mungkin perlu menangani dengan cara tertentu
        print('No signed-in user.');
        return null;
      }
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  // ingin mengecek apakah product tersebut sudah di like atau belum
  Stream<bool> checkIfProductLiked(Map<String, dynamic> product) async* {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        // Buat referensi koleksi produk
        CollectionReference productsCollection = FirebaseFirestore.instance
            .collection('favorites')
            .doc(userId)
            .collection('products');

        // Periksa apakah produk sudah ada di favorit berdasarkan nama
        QuerySnapshot<Object?> existingFavorite = await productsCollection
            .where('name', isEqualTo: product['name'])
            .get();

        // Kirim hasilnya ke stream
        yield existingFavorite.docs.isNotEmpty;
      } else {
        // Tampilkan snackbar bahwa User ID tidak tersedia
        Get.snackbar(
          'Error',
          'Failed to check if item is liked. User ID not available.',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Failed to check if item is liked. User ID not available.');
        // Kirim false ke stream jika terjadi kesalahan
        yield false;
      }
    } catch (e) {
      // Tampilkan snackbar jika terjadi kesalahan
      Get.snackbar(
        'Error',
        'Error checking if item is liked: $e',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error checking if item is liked: $e');
      // Kirim false ke stream jika terjadi kesalahan
      yield false;
    }
  }

  Future<void> addFavorite(Map<String, dynamic> product) async {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        // Gunakan transaksi untuk memastikan operasi atomik
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Buat referensi koleksi produk
          CollectionReference productsCollection = FirebaseFirestore.instance
              .collection('favorites')
              .doc(userId)
              .collection('products');

          // Cek apakah produk sudah ada di favorit berdasarkan nama
          QuerySnapshot<Object?> existingFavorite = await productsCollection
              .where('name', isEqualTo: product['name'])
              .get();

          if (existingFavorite.docs.isEmpty) {
            // Item belum ada di favorit, tambahkan ke favorit
            DocumentReference newProductRef = await productsCollection.add(
              {
                'timestamp': FieldValue.serverTimestamp(),
                'name': product['name'],
                'price': product['price'],
                'imageUrls': product['imageUrls'],
                'category': product['kategory'] ?? '',
                'sold': product['sold'],
                'description': product['description']
              },
            );

            // Tampilkan snackbar berhasil
            Get.snackbar(
              'Success',
              'Item added to favorites successfully.',
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            print(
                'Item added to favorites successfully with ID: ${newProductRef.id}');
          } else {
            for (QueryDocumentSnapshot<Object?> document
                in existingFavorite.docs) {
              // Hapus produk dari koleksi favorit berdasarkan ID dokumen
              await productsCollection.doc(document.id).delete();

              // Tampilkan snackbar berhasil
              Get.snackbar(
                'Success',
                'Item removed from favorites successfully.',
                duration: Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }
          }
        });
      } else {
        // Tampilkan snackbar bahwa User ID tidak tersedia
        Get.snackbar(
          'Error',
          'Failed to add item to favorites. User ID not available.',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Failed to add item to favorites. User ID not available.');
      }
    } catch (e) {
      // Tampilkan snackbar jika terjadi kesalahan
      Get.snackbar(
        'Error',
        'Error adding item to favorites: $e',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error adding item to favorites: $e');
    }
  }

  // Future<void> updateFavoriteStatus(String productId, bool isFavorite) async {
  //   try {
  //     String? userId = await getUserId();
  //     if (userId != null) {
  //       await firestore
  //           .collection('favorites')
  //           .doc(userId)
  //           .collection('products')
  //           .doc(productId)
  //           .set({
  //         'isFavorite': isFavorite,
  //         'timestamp': FieldValue.serverTimestamp(),
  //       });
  //       print('Favorite status updated successfully.');
  //     } else {
  //       print('Failed to update favorite status. User ID not available.');
  //     }
  //   } catch (e) {
  //     print('Error updating favorite status: $e');
  //   }
  // }

  Stream<List<Map<String, dynamic>>> fetchAll() async* {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        QuerySnapshot querySnapshot = await firestore
            .collection('favorites')
            .doc(userId)
            .collection('products')
            .get();

        List<Map<String, dynamic>> favoriteProducts = querySnapshot.docs
            .map((DocumentSnapshot doc) =>
                Map<String, dynamic>.from(doc.data() as Map))
            .toList();

        // Kirim data ke Stream
        yield favoriteProducts;
      } else {
        print('Failed to fetch favorites. User ID not available.');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }
}
