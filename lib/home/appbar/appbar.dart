import 'package:flutter/material.dart';
import 'package:wakul2/home/cart_screen.dart';
import 'package:wakul2/home/message/message_screen.dart';

TextEditingController searchController = TextEditingController();

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Container(
                      margin:
                          const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Search",
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MessagePage()),
                    );
                  },
                  child: const Icon(Icons.email_outlined),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to grocery store screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  child: const Icon(Icons.local_grocery_store_outlined),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
