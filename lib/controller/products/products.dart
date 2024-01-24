import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wakul2/Data/makanan.dart';

class MakananController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final makananlaceCollection =
      FirebaseFirestore.instance.collection('makanan');

  Future<QuerySnapshot<Map<String, dynamic>>> getMakananlace() async {
    return await makananlaceCollection.get();
  }

  Stream<QuerySnapshot<Object?>> streamKategoriMakanan() {
    CollectionReference kategoriRef = firestore.collection("categories");
    return kategoriRef.snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamDataByCategory(String documentId) {
    return firestore
        .collection("categories")
        .doc(documentId)
        .collection("products")
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamMakanan() {
    CollectionReference makananCollection =
        firestore.collection("categories").doc("food").collection("products");

    return makananCollection.snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamMinuman() {
    CollectionReference makananCollection =
        firestore.collection("categories").doc("drink").collection("products");

    return makananCollection.snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamSnack() {
    CollectionReference makananCollection =
        firestore.collection("categories").doc("snack").collection("products");

    return makananCollection.snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference products = firestore.collection("makanan");
    return products.snapshots();
  }

  Stream<List<Map<String, dynamic>>> getMakanan(Map<String, dynamic> product) {
    // Gunakan StreamController untuk mengirimkan data ke dalam stream
    StreamController<List<Map<String, dynamic>>> controller =
        StreamController();

    // Lakukan proses asinkron
    // Ambil referensi koleksi dari Firestore
    CollectionReference collection = firestore
        .collection("categories")
        .doc(product["idkategori"])
        .collection("products");

    // Dapatkan snapshot dari koleksi
    collection.snapshots().listen(
      (QuerySnapshot snapshot) {
        // Ambil data dari snapshot dan kirimkan ke stream
        List<Map<String, dynamic>> foodData = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        controller.add(foodData);
      },
      onError: (error) {
        // Tangani error jika terjadi
        controller.addError(error);
      },
    );

    // Kembalikan stream dari controller
    return controller.stream;
  }
}
