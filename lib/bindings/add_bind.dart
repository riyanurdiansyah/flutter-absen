import 'package:absensi_flutter/controllers/add_karyawan_c.dart';
import 'package:get/get.dart';

class AddKaryawanBind extends Bindings {
  @override
  void dependencies() {
    Get.put(AddKaryawanC());
  }
}
