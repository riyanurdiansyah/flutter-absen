import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStyleTextfield {
  static authTextFieldStyle() {
    return TextStyle(
      fontSize: Get.size.shortestSide < 600 ? 14 : 25,
    );
  }

  static authFormInput(String labelText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      labelText: labelText,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Get.size.shortestSide < 600 ? 12 : 23),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.errorColor),
          borderRadius: BorderRadius.circular(5)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.errorColor),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade600),
          borderRadius: BorderRadius.circular(5)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5)),
    );
  }

  InputDecoration kAuthTextFormInputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      labelText: labelText,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Get.size.shortestSide < 600 ? 12 : 23),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.errorColor),
          borderRadius: BorderRadius.circular(5)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.errorColor),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade600),
          borderRadius: BorderRadius.circular(5)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
