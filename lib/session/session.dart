import 'package:absensi_flutter/models/user_m.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  static Future saveSession(
    UserM users,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("role", users.role!);
    prefs.setString("name", users.name!);
    prefs.setString("email", users.email!);
    prefs.setString("handphone", users.handphone!);
    prefs.setString("uid", users.uid!);
  }

  static Future getSessionRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? result = prefs.getInt("role");

    return result;
  }

  static Future getSessionName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? result = prefs.getString("name");

    return result;
  }

  static Future getSessionHp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? result = prefs.getString("handphone");

    return result;
  }

  static Future getSessionUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? result = prefs.getString("uid");

    return result;
  }

  static Future clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("uid");
    prefs.remove("name");
    prefs.remove("role");
    prefs.remove("email");
    prefs.remove("handphone");
  }
}
