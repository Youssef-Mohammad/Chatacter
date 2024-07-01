import 'package:chatacter/config/app_icons.dart';
import 'package:chatacter/config/app_routes.dart';
import 'package:chatacter/config/app_strings.dart';
import 'package:chatacter/config/appwrire.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:chatacter/styles/app_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  String countryCode = AppStrings.initialCountaryCode;

  void handleOtpSubmit(BuildContext context, String userId) {
    if (_formKey1.currentState!.validate()) {
      loginWithOtp(otp: _otpController.text, userId: userId).then((value) {
        if (value) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
          print("Right OTP..............");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(AppStrings.loginFailed)));
          print("Failed OTP..............");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                  child: Image.asset(
                AppIcons.appPoster,
                fit: BoxFit.cover,
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.welcomeToChatApp,
                        style: AppText.welcomeFont),
                    Text(AppStrings.enterPhoneNumberToContinue),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.length != 10) {
                            return AppStrings.enterYourPhoneNumber;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: CountryCodePicker(
                            onChanged: (value) {
                              countryCode = value.dialCode!;
                              print(value.dialCode);
                            },
                            initialSelection:
                                AppStrings.initialCountarySelection,
                          ),
                          labelText: AppStrings.enterYourPhoneNumber,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(AppStrings.sendOTP),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createPhoneNumberSession(
                                    phone: countryCode +
                                        _phoneNumberController.text)
                                .then((value) {
                              if (value != 'Login Error') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title:
                                              Text(AppStrings.otpVerification),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  AppStrings.enterTheSixDigits),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Form(
                                                key: _formKey1,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _otpController,
                                                  validator: (value) {
                                                    if (value!.length != 6) {
                                                      return AppStrings
                                                          .invalidOtp;
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: AppStrings
                                                          .enterTheOtpReceived,
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  handleOtpSubmit(
                                                      context, value);
                                                },
                                                child: const Text(
                                                    AppStrings.submit))
                                          ],
                                        ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(AppStrings.failedToSendOtp)));
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                      ),
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