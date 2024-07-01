import 'package:chatacter/config/app_strings.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          AppStrings.friends,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(6)),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppStrings.enterPhoneNumber),
                    ),
                  ),
                  Icon(Icons.search),
                ],
              ),
            )),
      ),
    );
  }
}
