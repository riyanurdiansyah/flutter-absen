import 'package:absensi_flutter/session/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionC extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await saveSessionToController();
  }

  var id = ''.obs;
  var name = ''.obs;
  var role = 00.obs;

  Future<void> saveSessionToController() async {
    id.value = await AppSession.getSessionUid() ?? "";
    name.value = await AppSession.getSessionName() ?? "";
    role.value = await AppSession.getSessionRole() ?? 00;
  }

  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    await prefs.clear();
    // id.value = "";
    // name.value = "";
    // role.value = 00;
  }
}
