import 'package:absensi_flutter/controllers/admin_c.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RekapAbsenPage extends StatelessWidget {
  const RekapAbsenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final admC = Get.find<AdminC>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.labelW600(
                          'Tanggal',
                          12,
                          Colors.grey,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Obx(
                          () => AppText.labelBold(
                            DateFormat.yMMMd('id').format(
                              DateTime.parse(
                                admC.tanggal.value,
                              ),
                            ),
                            16,
                            Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 0.5,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.date_range_rounded,
                        color: Colors.lightBlue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => AppDialog.dialogDatePicker(),
                        child: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: admC.fnStreamAbsensi(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  admC.fnSaveAbsensi(snapshot.data!.docs);
                  return Expanded(
                    child: Obx(
                      () => ListView(
                        children: List.generate(
                          admC.listAbsen.length,
                          (i) => SizedBox(
                            height: 125,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 50,
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
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              admC.listAbsen[i].name!
                                                  .toUpperCase(),
                                              maxLines: 2,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Checkin :",
                                              style: GoogleFonts.nunito(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            Text(
                                              admC.listAbsen[i].timeIn! == "-"
                                                  ? "-"
                                                  : "${DateFormat('HH:mm:ss', 'id').format(
                                                      DateTime.parse(
                                                        admC.listAbsen[i]
                                                            .timeIn!,
                                                      ),
                                                    )} ${DateTime.parse(
                                                      admC.listAbsen[i].timeIn!,
                                                    ).timeZoneName}",
                                              style: GoogleFonts.nunito(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Checkout :",
                                              style: GoogleFonts.nunito(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            Text(
                                              admC.listAbsen[i].timeOut! == "-"
                                                  ? "-"
                                                  : "${DateFormat('HH:mm:ss', 'id').format(
                                                      DateTime.parse(
                                                        admC.listAbsen[i]
                                                            .timeOut!,
                                                      ),
                                                    )} ${DateTime.parse(
                                                      admC.listAbsen[i]
                                                          .timeOut!,
                                                    ).timeZoneName}",
                                              style: GoogleFonts.nunito(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        padding: const EdgeInsets.all(4),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                DateTime.parse(admC.listAbsen[i]
                                                                    .timeIn!)
                                                                .hour <
                                                            9 ||
                                                        (DateTime.parse(admC
                                                                        .listAbsen[
                                                                            i]
                                                                        .timeIn!)
                                                                    .hour >=
                                                                9 &&
                                                            DateTime.parse(admC
                                                                        .listAbsen[
                                                                            i]
                                                                        .timeIn!)
                                                                    .minute <
                                                                15)
                                                    ? 'On Time'
                                                    : 'Too Late',
                                                style:
                                                    GoogleFonts.dancingScript(
                                                  fontSize: 16,
                                                  color: DateTime.parse(admC
                                                                      .listAbsen[
                                                                          i]
                                                                      .timeIn!)
                                                                  .hour <
                                                              9 ||
                                                          (DateTime.parse(admC
                                                                          .listAbsen[
                                                                              i]
                                                                          .timeIn!)
                                                                      .hour >=
                                                                  9 &&
                                                              DateTime.parse(admC
                                                                          .listAbsen[
                                                                              i]
                                                                          .timeIn!)
                                                                      .minute <
                                                                  15)
                                                      ? Colors.blue
                                                      : Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 400,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}
