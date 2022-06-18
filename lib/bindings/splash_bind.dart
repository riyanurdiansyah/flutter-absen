import 'package:get/get.dart';
import '../controllers/splash_c.dart';

class SplashBind extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashC());
  }
}
