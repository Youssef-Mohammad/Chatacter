import 'package:chatacter/config/appwrire.dart';
import 'package:flutter/material.dart';
import 'package:chatacter/config/app_routes.dart';
import 'package:chatacter/styles/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Urbanist",
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
      ),
      initialRoute: AppRoutes.checkUserSession,
      routes: AppRoutes.pages,
    );
  }
}

class CheckUserSessions extends StatefulWidget {
  const CheckUserSessions({super.key});

  @override
  State<CheckUserSessions> createState() => _CheckUserSessionsState();
}

class _CheckUserSessionsState extends State<CheckUserSessions> {
  @override
  void initState() {
    checkSessions().then((value) {
      if (value) {
        print("Session is ononononon");
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
      } else {
        print("Session is ofofofofof");
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
