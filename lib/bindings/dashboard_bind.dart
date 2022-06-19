import 'package:absensi_flutter/controllers/admin_c.dart';
import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:get/get.dart';

class HomeBind extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeC());
    Get.put(AdminC());
  }
}
