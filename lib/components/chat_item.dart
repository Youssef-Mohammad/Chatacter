import 'package:chatacter/config/app_icons.dart';
import 'package:chatacter/config/app_routes.dart';
import 'package:chatacter/config/app_strings.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:chatacter/styles/app_text.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, AppRoutes.chat),
      leading: Stack(children: [
        CircleAvatar(
          backgroundImage: Image.asset(AppIcons.userIcon).image,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            radius: 6,
            backgroundColor: Colors.green,
          ),
        )
      ]),
      title: Text(AppStrings.otherUser),
      subtitle: Text(AppStrings.helloHowAreYou),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 10,
            child: Text(
              AppStrings.nine,
              style: AppText.numberOfMessagesFont,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(AppStrings.fourPastHalf)
        ],
      ),
    );
  }
}
