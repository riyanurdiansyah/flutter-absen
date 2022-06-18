import 'package:get/get.dart';

import '../controllers/auth_c.dart';

class AuthBind extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthC());
  }
}
