import 'package:absensi_flutter/session/session.dart';
import 'package:get/get.dart';

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
    id.value = await AppSession.getSessionUid();
    name.value = await AppSession.getSessionName();
    role.value = await AppSession.getSessionRole();
  }
}
