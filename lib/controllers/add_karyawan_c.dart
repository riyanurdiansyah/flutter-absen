import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddKaryawanC extends GetxController {
  final formKey = GlobalKey<FormState>();

  final tcNik = TextEditingController();
  final tcNama = TextEditingController();
  final tcEmail = TextEditingController();
  final tcHp = TextEditingController();
  final tcPassword = TextEditingController();

  var isObsecure = true.obs;

  void changeVisibilityPass() {
    isObsecure.value = !isObsecure.value;
  }
}
