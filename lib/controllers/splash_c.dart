import 'package:absensi_flutter/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'session_c.dart';

class SplashC extends GetxController {
  final _sessionC = Get.find<SessionC>();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString('uid');
        if (uid != null) {
          return Get.offAllNamed(AppRouteName.home);
        } else {
          return Get.offAllNamed(AppRouteName.auth);
        }
      },
    );
  }
}
