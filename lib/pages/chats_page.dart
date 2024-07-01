import 'package:chatacter/components/chat_item.dart';
import 'package:chatacter/components/tool_bar.dart';
import 'package:chatacter/config/app_strings.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ToolBar(title: AppStrings.chats),
      body: ListView.builder(
          itemCount: 20, itemBuilder: (context, index) => ChatItem()),
    );
  }
}
