import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PembayaranController {
  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transaksi');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID
  String? get userId => _auth.currentUser?.uid;

  void addTransaction(
    int jumlahOrder,
    String tanggalOrder,
    String catatan,
    String waktuOrder,
    String alamatPenerima,
    String totalHarga,
    Map<String, dynamic> products,
  ) async {
    try {
      if (userId != null) {
        DocumentReference transactionDocRef =
            transactionsCollection.doc(userId);

        // Check if the document already exists
        DocumentSnapshot<Object?> existingTransaction =
            await transactionDocRef.get();

        if (existingTransaction.exists) {
          // Update existing transaction by adding the new product
          await transactionDocRef.update({
            'products': FieldValue.arrayUnion([
              {
                'name': products["name"],
                'price': products["price"] * jumlahOrder,
                'idProduct': products["idProduct"],
                'jumlah_order': jumlahOrder,
              },
            ]),
          });
        } else {
          // Create a new transaction document if it doesn't exist
          await transactionDocRef.set({
            'catatan': catatan,
            'tanggal_order': tanggalOrder,
            'waktu_order': waktuOrder,
            'alamat_penerima': alamatPenerima,
            'total_harga': totalHarga,
            'products': [
              {
                'name': products["name"],
                'price': products["price"] * jumlahOrder,
                'idProduct': products["idProduct"],
                'jumlah_order': jumlahOrder,
              },
            ],
            'userId': userId,
          });
        }
      }
    } catch (e) {
      print('Error adding/updating transaction: $e');
    }
  }

  // Fetch a list of all transactions for the current user from the database
  Stream<List<Map<String, dynamic>>> fetchAllTransactions() {
    return transactionsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  // Update transaction details in the database
  Future<void> updateTransaction(
      String transactionId, Map<String, dynamic> updatedData) async {
    try {
      await transactionsCollection.doc(transactionId).update(updatedData);
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  // Delete a transaction from the database
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }
}
