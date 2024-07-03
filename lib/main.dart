import 'package:camera/camera.dart';
import 'package:chatacter/data/local_saved_data.dart';
import 'package:chatacter/config/appwrire.dart';
import 'package:chatacter/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:chatacter/config/app_routes.dart';
import 'package:chatacter/styles/app_colors.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  await LocalSavedData.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Urbanist",
          scaffoldBackgroundColor: AppColors.background,
          brightness: Brightness.dark,
        ),
        // initialRoute: AppRoutes.video,
        initialRoute: AppRoutes.checkUserSession,
        routes: AppRoutes.pages,
      ),
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
    super.initState();

    //Load data from local
    Future.delayed(Duration.zero, () {
      Provider.of<UserDataProvider>(context, listen: false).LoadDataFromLocal();
    });

    final userName =
        Provider.of<UserDataProvider>(context, listen: false).getUserName;
    print('UserName: $userName Here!');

    checkSessions().then((value) {
      if (value) {
        print("Session is ononononon");
        if (userName != '') {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.editProfile, (route) => false,
              arguments: {'title': 'add'});
        }
      } else {
        print("Session is ofofofofof");
        Navigator.of(context)
            // .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            .pushNamedAndRemoveUntil(AppRoutes.video, (route) => false);
      }
    });
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
