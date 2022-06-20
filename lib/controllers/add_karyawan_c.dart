import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/services/home_service.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddKaryawanC extends GetxController {
  final _txUsername = TextEditingController().obs;
  TextEditingController get txUsername => _txUsername.value;

  final _txNama = TextEditingController().obs;
  TextEditingController get txNama => _txNama.value;

  final _txEmail = TextEditingController().obs;
  TextEditingController get txEmail => _txEmail.value;

  final _txHp = TextEditingController().obs;
  TextEditingController get txHp => _txHp.value;

  final _txPass = TextEditingController().obs;
  TextEditingController get txPass => _txPass.value;

  final Rx<bool> _isHidePassword = true.obs;
  Rx<bool> get isHidePassword => _isHidePassword;

  final Rx<bool> _isLoading = false.obs;
  Rx<bool> get isLoading => _isLoading;

  final _homeService = HomeService();

  void hidePassword() {
    _isHidePassword.value = !_isHidePassword.value;
  }

  void fnAddKaryawan() async {
    _isLoading.value = true;
    final user = UserM(
      name: _txNama.value.text,
      handphone: _txNama.value.text,
      password: _txPass.value.text,
      email: _txEmail.value.text,
      lat: 0.1,
      lng: 0.1,
      role: 2,
      status: true,
      username: _txUsername.value.text,
      profilePict: '',
    );
    final response = await _homeService.addKaryawan(user);
    if (response) {
      fnClearTextEditor();
      Get.back();
      AppDialog.dialogWithRoute('Berhasil', 'Karyawan berhasil ditambahkan');
    }
    _isLoading.value = false;
  }

  void fnClearTextEditor() {
    _txEmail.value.clear();
    _txUsername.value.clear();
    _txHp.value.clear();
    _txPass.value.clear();
    _txNama.value.clear();
  }
}
