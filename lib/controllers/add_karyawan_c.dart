import 'package:absensi_flutter/models/user_m.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../services/home_service.dart';

class AddKaryawanC extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _homeService = HomeService();

  final tcNik = TextEditingController();
  final tcNama = TextEditingController();
  final tcEmail = TextEditingController();
  final tcHp = TextEditingController();
  final tcPassword = TextEditingController();

  var isObsecure = true.obs;
  var isLoading = false.obs;

  void changeVisibilityPass() {
    isObsecure.value = !isObsecure.value;
  }

  Future registerNewUser() async {
    isLoading.value = true;
    await _homeService.registerWithEmail(
      UserM(
        email: tcEmail.text,
        handphone: tcHp.text,
        username: tcNik.text,
        name: tcNama.text,
        role: 2,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        profilePict: "",
        status: true,
        lat: 0.0,
        lng: 0.0,
      ),
      tcPassword.text,
    );
    await Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.back();
      Fluttertoast.showToast(msg: "User berhasil ditambahkan");
    });
  }
}
