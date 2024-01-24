import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  late FocusNode focusnode;
  late TextEditingController chatController;

  void addEmojiToChat(Emoji emoji) {
    chatController.text = chatController.text + emoji.emoji;
  }

  void deleteEmojitoChat() {
    chatController.text =
        chatController.text.substring(0, chatController.text.length - 2);
  }

  @override
  void onInit() {
    chatController = TextEditingController();
    focusnode = FocusNode();
    focusnode.addListener(() {
      if (focusnode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatController.dispose();
    focusnode.dispose();
    super.onClose();
  }
}
