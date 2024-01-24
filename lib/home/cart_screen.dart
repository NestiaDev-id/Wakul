import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wakul2/controller/card_controller.dart';
import 'package:wakul2/home/countdouwn.dart';
import 'package:wakul2/home/menu_pembayaran.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController controller = CartController();
  final AddCartController addCartController = AddCartController();
  List<int> counts = [];
  int total = 0;
  var formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();

    // Memasang listener pada totalStream untuk memperbarui total
    updateTotal();
  }

  // Fungsi untuk memperbarui total berdasarkan data keranjang
  Future<void> updateTotal() async {
    int totalItems = await addCartController.getCartItemsCount();
    setState(() {
      total = totalItems;
      print('Number of items in the cartsss: $total');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: addCartController.fetchCart(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Your cart is empty.');
            } else {
              // Hapus baris ini karena kita sudah punya listener pada totalStream
              // int totalItems = snapshot.data!.length;
              // total = totalItems;

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        snapshot.data![index]['imageUrls'],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data![index]['name'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            formatCurrency.format(
                                                snapshot.data![index]["price"] *
                                                    (counts.length > index
                                                        ? counts[index]
                                                        : 1)),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Staatliches',
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          CountdownWidget2(
                                            pangan: snapshot.data![index],
                                            count: counts.length > index
                                                ? counts[index]
                                                : 1,
                                            onCountChanged: (newCount) {
                                              setState(() {
                                                if (counts.length > index) {
                                                  counts[index] = newCount;
                                                } else {
                                                  counts.add(newCount);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Text('Total Pesanan ${calculateTotalOrder(total, counts)}'),
        ),
      ),
    );
  }

  int calculateTotalOrder(int total, List<int> counts) {
    int totalOrder = total;

    for (int count in counts) {
      totalOrder += count;
    }

    return totalOrder;
  }
}

class CartController {
  // Membuat stream controller untuk total
  StreamController<void> _totalController = StreamController<void>.broadcast();

  // Getter untuk stream total
  Stream<void> get totalStream => _totalController.stream;

  // Fungsi untuk memberitahu perubahan total
  void notifyTotal() {
    _totalController.add(null);
  }

  // Membersihkan sumber daya
  void dispose() {
    _totalController.close();
  }
}
