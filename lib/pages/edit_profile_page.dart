import 'package:flutter/material.dart';
import 'package:chatacter/components/app_textfield.dart';
import 'package:chatacter/components/tool_bar.dart';
import 'package:chatacter/components/user_avatar.dart';
import 'package:chatacter/config/app_strings.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:chatacter/styles/app_text.dart';

enum Gender { none, male, female, other }

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var gender = Gender.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToolBar(
        title: AppStrings.editProfile,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: UserAvatar(
                      size: 120,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: AppColors.black,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              AppTextfield(hint: AppStrings.firstName),
              SizedBox(
                height: 16,
              ),
              AppTextfield(hint: AppStrings.lastName),
              SizedBox(
                height: 16,
              ),
              AppTextfield(hint: AppStrings.phoneNumber),
              SizedBox(
                height: 16,
              ),
              AppTextfield(hint: AppStrings.location),
              SizedBox(
                height: 16,
              ),
              AppTextfield(hint: AppStrings.birthday),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.only(left: 12, right: 12, top: 6),
                decoration: BoxDecoration(
                    color: AppColors.fieldColor,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.gender,
                      style: AppText.body1.copyWith(fontSize: 12),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            activeColor: AppColors.fieldCursorColor,
                            visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              AppStrings.male,
                              style: AppText.body1,
                            ),
                            value: Gender.male,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = Gender.male;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            activeColor: AppColors.fieldCursorColor,
                            visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              AppStrings.female,
                              style: AppText.body1,
                            ),
                            value: Gender.female,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = Gender.female;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            activeColor: AppColors.fieldCursorColor,
                            visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              AppStrings.other,
                              style: AppText.body1,
                            ),
                            value: Gender.other,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = Gender.other;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
