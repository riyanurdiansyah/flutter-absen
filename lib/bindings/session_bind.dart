import 'package:get/get.dart';

import '../controllers/session_c.dart';

class SessionBind extends Bindings {
  @override
  void dependencies() {
    Get.put(SessionC());
  }
}
