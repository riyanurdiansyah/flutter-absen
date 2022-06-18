import 'package:absensi_flutter/controllers/absen_c.dart';
import 'package:get/get.dart';

class AbsenBind extends Bindings {
  @override
  void dependencies() {
    Get.put(AbsenC());
  }
}
