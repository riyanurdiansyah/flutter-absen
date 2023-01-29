import 'package:absensi_flutter/routes/routes_name.dart';
import 'package:get/get.dart';
import 'session_c.dart';

class SplashC extends GetxController {
  final _sessionC = Get.find<SessionC>();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (_sessionC.id.isNotEmpty) {
          return Get.offAllNamed(AppRouteName.home);
        } else {
          return Get.offAllNamed(AppRouteName.auth);
        }
      },
    );
  }
}
