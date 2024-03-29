import 'package:absensi_flutter/controllers/admin_c.dart';
import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/pages/admin/rekap_absen_page.dart';
import 'package:absensi_flutter/pages/home/home_page.dart';
import 'package:absensi_flutter/pages/kelola_karyawan_page.dart';
import 'package:absensi_flutter/pages/home/master_lokasi.dart';
import 'package:absensi_flutter/routes/routes_name.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);
  final homeC = Get.find<HomeC>();
  final admC = Get.find<AdminC>();
  final sessionC = Get.find<SessionC>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: admC.scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.toNamed(AppRouteName.drawer),
          icon: const Icon(
            CupertinoIcons.square_grid_2x2_fill,
            color: Colors.white,
          ),
        ),
        title: Obx(
          () => AppText.labelBold(
            homeC.title.value,
            16,
            Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade300,
              ],
            ),
          ),
        ),
        actions: [
          Obx(
            () {
              if (homeC.indexTab.value == 3) {
                return IconButton(
                  onPressed: () => Get.toNamed(AppRouteName.addKaryawan),
                  icon: const Icon(
                    Icons.person_add_alt_rounded,
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: homeC.indexTab.value,
          children: [
            HomePage(),
            const MasterLokasi(),
            RekapAbsenPage(),
            KelolaKaryawanPage(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => homeC.indexTab.value == 0 && sessionC.role.value != 1
            ? SizedBox(
                width: Get.width / 1.2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRouteName.absen, arguments: [0]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.input_rounded,
                                  color: Colors.grey.shade600,
                                ),
                                Text(
                                  "CHECKIN",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () =>
                              Get.toNamed(AppRouteName.absen, arguments: [1]),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "CHECKOUT",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.output_rounded,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
