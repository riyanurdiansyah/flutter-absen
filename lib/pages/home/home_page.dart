import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeC>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: homeC.fnStreamAbsenById(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  homeC.saveRekap(snapshot.data!.docs);
                  return Card(
                    elevation: 2,
                    color: Colors.blue.shade400,
                    semanticContainer: true,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -225,
                          bottom: -15,
                          width: Get.width,
                          height: Get.height / 5,
                          child: SvgPicture.asset(
                            "assets/svg/result.svg",
                            colorBlendMode: BlendMode.clear,
                            width: 150,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: Get.width,
                          height: Get.height / 5,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CircularPercentIndicator(
                                  backgroundColor: Colors.grey.shade400,
                                  progressColor: Colors.white,
                                  animation: true,
                                  reverse: true,
                                  radius: 60.0,
                                  lineWidth: 12.0,
                                  percent: homeC.listRekap.isEmpty
                                      ? 0
                                      : homeC.persentase.value / 100,
                                  center: Text(
                                    "${homeC.listRekap.isEmpty ? 0.0 : homeC.persentase.round()} %",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Persentase Ketepatan Waktu Bulan Ini",
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Persentase anda ${homeC.persentase.value.round()}%",
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: GoogleFonts.aBeeZee(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 125,
                    alignment: Alignment.center,
                    child: GetPlatform.isAndroid
                        ? const CircularProgressIndicator()
                        : const CupertinoActivityIndicator(),
                  );
                }
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Aktivitas Terakhir",
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lihat semua",
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.blue.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: homeC.fnStreamAbsenById(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  homeC.saveAbsen(snapshot.data!.docs);
                  return Column(
                    children: List.generate(
                      homeC.listAbsen.length <= 3 ? homeC.listAbsen.length : 3,
                      (i) => TimelineTile(
                        afterLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                        ),
                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                        ),
                        indicatorStyle: IndicatorStyle(
                          indicatorXY: 0.15,
                          width: 15,
                          indicator: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        isFirst: i == 0,
                        isLast: homeC.listAbsen.length <= 3
                            ? i == homeC.listAbsen.length - 1
                            : i == 2,
                        endChild: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Colors.grey.shade400.withOpacity(0.8),
                                    ),
                                    child: AppText.labelBold(
                                      DateFormat.yMMMd('id').format(
                                        DateTime.parse(
                                          homeC.listAbsen[i].date!,
                                        ),
                                      ),
                                      12,
                                      Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Checkin :",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        homeC.listAbsen[i].timeIn! == "-"
                                            ? "-"
                                            : "${DateFormat('HH:mm:ss', 'id').format(
                                                DateTime.parse(
                                                  homeC.listAbsen[i].timeIn!,
                                                ),
                                              )} ${DateTime.parse(
                                                homeC.listAbsen[i].timeIn!,
                                              ).timeZoneName}",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        homeC.listAbsen[i].timeOut! == "-"
                                            ? "-"
                                            : "${DateFormat('HH:mm:ss', 'id').format(
                                                DateTime.parse(
                                                  homeC.listAbsen[i].timeOut!,
                                                ),
                                              )} ${DateTime.parse(
                                                homeC.listAbsen[i].timeOut!,
                                              ).timeZoneName}",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
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
                                        DateTime.parse(homeC.listAbsen[i]
                                                            .timeIn!)
                                                        .hour <
                                                    9 ||
                                                (DateTime.parse(homeC
                                                                .listAbsen[i]
                                                                .timeIn!)
                                                            .hour >=
                                                        9 &&
                                                    DateTime.parse(homeC
                                                                .listAbsen[i]
                                                                .timeIn!)
                                                            .minute <
                                                        15)
                                            ? 'On Time'
                                            : 'Too Late',
                                        style: GoogleFonts.dancingScript(
                                          fontSize: 16,
                                          color: DateTime.parse(homeC
                                                              .listAbsen[i]
                                                              .timeIn!)
                                                          .hour <
                                                      9 ||
                                                  (DateTime.parse(homeC
                                                                  .listAbsen[i]
                                                                  .timeIn!)
                                                              .hour >=
                                                          9 &&
                                                      DateTime.parse(homeC
                                                                  .listAbsen[i]
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
                              )
                              // homeC.listAbsen[i].image! == "-"
                              //     ? const SizedBox()
                              //     : Container(
                              //         height: 80,
                              //         width: 80,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(4),
                              //           image: DecorationImage(
                              //             image: NetworkImage(
                              //               homeC.listAbsen[i].image!,
                              //             ),
                              //             fit: BoxFit.cover,
                              //           ),
                              //         ),
                              //       )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: GoogleFonts.aBeeZee(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 125,
                    alignment: Alignment.center,
                    child: GetPlatform.isAndroid
                        ? const CircularProgressIndicator()
                        : const CupertinoActivityIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
