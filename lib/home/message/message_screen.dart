import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakul2/Route/routes.dart';
import 'package:wakul2/home/message/chatroom_screen.dart';

class MessagePage extends GetView {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> myChats = List.generate(
      20,
      (index) {
        return ListTile(
          onTap: () {
            // Get.toNamed(Routes.CHAT_ROOM);
            Get.to(() => const ChatRoomPage());
          },
          leading: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black26,
            // child: Image.asset(
            //   'assets/your_image.png', // Replace with the actual path to your image asset
            //   width: 24, // Adjust the width as needed
            //   height: 24, // Adjust the height as needed
            // ),
          ),
          title: Text('Orang ${index + 1}'),
          subtitle: Text('Status  ${index + 1}'),
          trailing: Chip(
            label: const Text("3"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.grey,
            labelStyle: const TextStyle(color: Colors.white),
          ),
        );
      },
    ).reversed.toList();

    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: myChats.length,
              itemBuilder: (context, index) => myChats[index],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(
          Icons.message_rounded,
        ),
      ),
    );
  }
}
