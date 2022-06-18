import 'package:absensi_flutter/routes/routes_name.dart';
import 'package:absensi_flutter/services/auth_service.dart';
import 'package:absensi_flutter/session/session.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_c.dart';

class AuthC extends GetxController {
  final _sC = Get.find<SessionC>();
  final _signinKey = GlobalKey<FormState>();
  GlobalKey<FormState> get signinKey => _signinKey;

  final _scaffoldSignin = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldSignin => _scaffoldSignin;

  final _txUsername = TextEditingController().obs;
  TextEditingController get txUsername => _txUsername.value;

  final _txPass = TextEditingController().obs;
  TextEditingController get txPass => _txPass.value;

  final Rx<bool> _isHidePassword = true.obs;
  Rx<bool> get isHidePassword => _isHidePassword;

  final Rx<bool> _isLoading = false.obs;
  Rx<bool> get isLoading => _isLoading;

  final _authService = AuthService();

  void hidePassword() {
    _isHidePassword.value = !_isHidePassword.value;
  }

  void changeLoading() {
    _isLoading.value = !_isLoading.value;
  }

  void fnLogin() async {
    FocusScope.of(_scaffoldSignin.currentContext!).requestFocus(FocusNode());
    if (_signinKey.currentState!.validate()) {
      changeLoading();
      final email = await _authService.getEmail(_txUsername.value.text);
      if (email != null) {
        final response = await _authService.signin(
          email,
          _txPass.value.text,
        );
        Future.delayed(
          const Duration(seconds: 3),
          () async {
            changeLoading();
            if (response != null) {
              final data = await _authService.getInfoUser(response);
              print("RES: $response");
              print("DATA: $data");
              if (data != null) {
                await AppSession.saveSession(data);
                await _sC.saveSessionToController();
                return Get.offAllNamed(AppRouteName.home);
              }
            } else {
              changeLoading();
              AppDialog.dialogWithRoute(
                  "Ooppss...", 'Terjadi kesalah silahkan coba sesaat lagi');
            }
          },
        );
      } else {
        changeLoading();
        AppDialog.dialogWithRoute(
            "Ooppss...", 'NIK belum terdaftar didalam sistem');
      }
    }
  }
}
