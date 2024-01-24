import 'package:get/get.dart';
import 'package:wakul2/home/message/chatroom_screen.dart';

class Routes {
  static const String CHAT_ROOM = '/chat-room';

  final getPages = [
    GetPage(
      name: CHAT_ROOM,
      page: () => const ChatRoomPage(),
    ),
  ];
}
