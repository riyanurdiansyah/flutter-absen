import 'package:absensi_flutter/controllers/absen_c.dart';
import 'package:absensi_flutter/controllers/admin_c.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/routes/routes_name.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppDialog {
  static dialogWithRoute(
    String title,
    String content, {
    String? route,
  }) {
    return Get.defaultDialog(
      contentPadding: const EdgeInsets.all(20),
      title: title,
      middleText: content,
      titleStyle: GoogleFonts.nunito(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      textConfirm: "Close",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (route == null) {
          Get.back();
        } else {
          Get.toNamed(route);
        }
      },
    );
  }

  static dialogConfirmCheckin(UserM user) {
    final aC = Get.find<AbsenC>();
    final check = aC.args.value == 0 ? "Checkin" : "Checkout";
    return Get.defaultDialog(
      contentPadding: const EdgeInsets.all(20),
      title: "Konfirmasi",
      middleText: "$check hanya bisa dilakukan 1x \n Anda yakin ?",
      titleStyle: GoogleFonts.nunito(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      textConfirm: "Yakin",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (aC.args.value == 0) {
          aC.fnSaveCheckin(user);
          Get.back();
        } else {
          aC.fnSaveCheckout(user);
          Get.back();
        }
        Get.back();
      },
    );
  }

  static dialogFakeGPS() {
    return Get.defaultDialog(
      barrierDismissible: false,
      contentPadding: const EdgeInsets.all(20),
      title: "PERINGATAN!!!!",
      middleText: "MATIKAN APLIKASI FAKE GPS NYA!!!",
      titleStyle: GoogleFonts.nunito(
        fontSize: 18,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.w500,
      ),
      textConfirm: "Close",
      confirm: InkWell(
        onTap: () => Get.offAllNamed(AppRouteName.home),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          height: 45,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.red,
          ),
          child: Text(
            "TUTUP",
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.offAllNamed(AppRouteName.home);
      },
    );
  }

  static dialogDatePicker() {
    final admC = Get.find<AdminC>();
    return showCupertinoModalPopup(
      context: admC.scaffoldkey.currentState!.context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AppText.labelW500(
                      "Batal",
                      14,
                      Colors.grey.shade400,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AppText.labelW600(
                      "Pilih",
                      14,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: CupertinoDatePicker(
                dateOrder: DatePickerDateOrder.dmy,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.parse(admC.tanggal.value),
                maximumYear: DateTime.now().year,
                minimumYear: DateTime.now().year - 1,
                minimumDate: DateTime(DateTime.now().year - 5, 1, 1),
                onDateTimeChanged: (date) => admC.onTapDate(date),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bottomSheetUser(UserM user) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: Get.height / 5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/profile.png',
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelBold(
                  user.name!.toUpperCase(),
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppText.labelBold(
                  user.handphone!,
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    AppText.labelW500(
                      'terakhir update : ',
                      14,
                      Colors.black,
                    ),
                    AppText.labelBold(
                      '${DateFormat.jms('id').format(DateTime.parse(user.updatedAt!))} WIB',
                      14,
                      Colors.black,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
