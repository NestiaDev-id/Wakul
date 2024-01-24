import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakul2/controller/card_controller.dart';
import 'package:wakul2/controller/products/delete_products.dart';
import 'package:wakul2/controller/products/favorite_product.dart';
import 'package:wakul2/controller/products/products.dart';
import 'package:wakul2/home/cart_screen.dart';
import 'package:wakul2/home/crud/edit_product.dart';
import 'package:wakul2/home/menu_pembayaran.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:wakul2/controller/users/userController.dart';

class DetailScreenFood extends StatefulWidget {
  final Map<String, dynamic> pangan;

  const DetailScreenFood({Key? key, required this.pangan}) : super(key: key);

  @override
  _DetailScreenFoodState createState() => _DetailScreenFoodState();
}

class _DetailScreenFoodState extends State<DetailScreenFood> {
  var count = 0;
  bool isProductLiked = false;

  @override
  Widget build(BuildContext context) {
    var formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    print(widget.pangan);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  child: Image.network(
                    widget.pangan["imageUrls"],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      if (count == 0)
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.local_grocery_store_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      if (count > 0)
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: badges.Badge(
                            badgeContent: Text("$count"),
                            badgeAnimation: const badges.BadgeAnimation.scale(),
                            child: IconButton(
                              icon: const Icon(
                                Icons.local_grocery_store_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pangan["name"],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontFamily: 'Staatliches',
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StreamBuilder<bool>(
                            stream: FavoriteController()
                                .checkIfProductLiked(widget.pangan),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Icon(Icons.favorite_border);
                              }

                              bool isProductLiked = snapshot.data ?? false;

                              return IconButton(
                                icon: Icon(
                                  isProductLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await FavoriteController()
                                      .addFavorite(widget.pangan);
                                  setState(() {
                                    isProductLiked = !isProductLiked;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10,
                      bottom: 5,
                    ),
                    child: Text(
                      formatCurrency.format(widget.pangan["price"]),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          'Terjual: ${widget.pangan["sold"]}',
                        ),
                        const Spacer(),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: UserController().streamRole(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return const CircularProgressIndicator();
                            }

                            String? role = snapshot.data!.data()!["roles"];

                            if (role == "seller") {
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProductView(
                                            kategori: widget.pangan,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: const Icon(Icons.edit,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Konfirmasi Hapus"),
                                            content: Text(
                                                "Apakah Anda yakin ingin menghapus produk ini?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // Batalkan penghapusan
                                                },
                                                child: Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      true); // Konfirmasi penghapusan
                                                },
                                                child: Text("Ya"),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        bool success =
                                            await DeleteProductController()
                                                .deleteItemFromFirestore(
                                          widget.pangan["idkategori"],
                                          widget.pangan["idProduct"],
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(success
                                                  ? "Produk Dihapus"
                                                  : "Kesalahan"),
                                              content: Text(success
                                                  ? "Produk berhasil dihapus."
                                                  : "Gagal menghapus produk."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Tutup dialog
                                                    if (success) {
                                                      Navigator.pop(
                                                          context); // Kembali ke layar sebelumnya
                                                    }
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Center(
                                        child: Icon(Icons.delete,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Deskripsi',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.pangan["description"]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.065,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.message_outlined),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuPembayaran(
                                          pangan: widget.pangan,
                                        )),
                              );
                            },
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            child: const Text('Beli'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.amber,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                AddCartController().addToCart(widget.pangan);
                                setState(() {
                                  count++;
                                });
                              },
                              child: const Center(
                                child: Text(
                                  'Keranjang',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: const Icon(
                                Icons.local_grocery_store_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
