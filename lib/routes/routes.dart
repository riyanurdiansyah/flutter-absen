import 'package:absensi_flutter/bindings/absen_bind.dart';
import 'package:absensi_flutter/bindings/auth_bind.dart';
import 'package:absensi_flutter/bindings/dashboard_bind.dart';
import 'package:absensi_flutter/bindings/splash_bind.dart';
import 'package:absensi_flutter/pages/absen_page.dart';
import 'package:absensi_flutter/pages/auth/login_page.dart';
import 'package:absensi_flutter/pages/drawer_page.dart';
import 'package:absensi_flutter/pages/dashboard_page.dart';
import 'package:absensi_flutter/pages/splash_page.dart';

import 'routes_name.dart';
import 'package:get/get.dart';

class AppRoute {
  static final routes = [
    GetPage(
      name: AppRouteName.splash,
      page: () => const SplashPage(),
      binding: SplashBind(),
    ),
    GetPage(
      name: AppRouteName.auth,
      page: () => const LoginPage(),
      binding: AuthBind(),
    ),
    GetPage(
      name: AppRouteName.home,
      page: () => const DashboardPage(),
      binding: HomeBind(),
    ),
    GetPage(
      name: AppRouteName.drawer,
      page: () => const DrawerPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: AppRouteName.absen,
      page: () => const AbsenPage(),
      binding: AbsenBind(),
      transition: Transition.leftToRight,
    ),
  ];
}
