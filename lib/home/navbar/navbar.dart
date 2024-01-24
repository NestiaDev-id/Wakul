import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakul2/account/accountScreen.dart';
import 'package:wakul2/controller/users/userController.dart';
import 'package:wakul2/favorite/favoriteScreen.dart';
import 'package:wakul2/home/detail_screen_category.dart';
import 'package:wakul2/home/favorite_screen.dart';
import 'package:wakul2/home/home.dart';
import 'package:wakul2/home/pesanan_screen.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  int _currentIndex = 0;

  final List<Widget> tabs = [
    const HomePage(),
    const Center(
      child: Text('Menu2'),
    ),
    // PesananPagState(),
    const FavoritePage(),
    // const DetailScreenCategory(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: UserController().streamRole(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   // Handle loading state
          //   return Container(
          //     color: Colors.white,
          //   );
          // }
          if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Tampilkan pesan error jika terjadi kesalahan
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox(); // Tampilkan pesan jika data null
          }
          String role = snapshot.data!.data()!["roles"];

          return Scaffold(
            body: tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.amber,
              items: buildNavigationBarItems(role),
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
            ),
          );
        });
  }

  List<BottomNavigationBarItem> buildNavigationBarItems(String role) {
    if (role == "seller") {
      // Hide some tabs for certain roles
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wallet_rounded),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.document_scanner_outlined),
          label: 'Rekap',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ];
    } else if (role == "driver") {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.follow_the_signs_outlined),
          label: 'Rekam Jejak',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Pesanan Saya',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ];
    }
  }
}
