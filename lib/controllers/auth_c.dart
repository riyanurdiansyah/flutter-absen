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

  Future changeLoading(bool val) async {
    _isLoading.value = val;
  }

  void fnLogin() async {
    FocusScope.of(_scaffoldSignin.currentContext!).requestFocus(FocusNode());
    if (_signinKey.currentState!.validate()) {
      changeLoading(true);
      final email = await _authService.getEmail(_txUsername.value.text);
      if (email != null) {
        final response = await _authService.signin(
          email,
          _txPass.value.text,
        );
        Future.delayed(
          const Duration(seconds: 3),
          () async {
            if (response != null) {
              final data = await _authService.getInfoUser(response);
              if (data != null) {
                await AppSession.saveSession(data);
                await _sC.saveSessionToController();
                await changeLoading(false);
                return Get.offAllNamed(AppRouteName.home);
              }
            } else {
              await changeLoading(false);
              AppDialog.dialogWithRoute(
                  "Ooppss...", 'Terjadi kesalah silahkan coba sesaat lagi');
            }
          },
        );
      } else {
        await changeLoading(false);
        AppDialog.dialogWithRoute(
            "Ooppss...", 'NIK belum terdaftar didalam sistem');
      }
    }
  }
}
