import 'package:chatacter/pages/edit_profile_page.dart';
import 'package:chatacter/pages/login_page.dart';
import 'package:chatacter/pages/main_page.dart';
import 'package:chatacter/pages/nearby_page.dart';

class AppRoutes {
  static const login = "/";
  static const home = "/home";
  static const main = "/main";
  static const editProfile = "/edit_profile";
  static const nearby = "/nearby";

  static final pages = {
    login: (context) => LoginPage(),
    main: (context) => MainPage(),
    editProfile: (context) => EditProfilePage(),
    nearby: (context) => NearbyPage(),
  };
}
