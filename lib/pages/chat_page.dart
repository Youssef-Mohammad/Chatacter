import 'package:chatacter/models/message.dart';
import 'package:chatacter/components/message_item.dart';
import 'package:chatacter/config/app_icons.dart';
import 'package:chatacter/config/app_strings.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:chatacter/styles/app_text.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  List messages = [
    Message(
        message: "Hello!",
        sender: "101",
        receiver: "102",
        timestamp: DateTime(2000),
        isSeenByReceiver: true),
    Message(
        message: "Hi!",
        sender: "102",
        receiver: "101",
        timestamp: DateTime(2000),
        isSeenByReceiver: false),
    Message(
        message: "How are you doing!",
        sender: "101",
        receiver: "102",
        timestamp: DateTime(2000),
        isSeenByReceiver: false),
    Message(
        message: "How are you doing!",
        sender: "101",
        receiver: "102",
        timestamp: DateTime(2000),
        isSeenByReceiver: false,
        isImage: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leadingWidth: 40,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.asset(AppIcons.userIcon).image,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.otherUser,
                  style: AppText.friendChatNameFont,
                ),
                Text(
                  AppStrings.online,
                  style: AppText.onlineFont,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) => MessageItem(
                        message: messages[index],
                        currentUser: "101",
                        isImage: true)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppStrings.typeMessage,
                        hintStyle: TextStyle(color: AppColors.grey)),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
