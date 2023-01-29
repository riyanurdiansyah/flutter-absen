import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/routes/routes_name.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerPage extends StatelessWidget {
  DrawerPage({Key? key}) : super(key: key);
  final homeC = Get.find<HomeC>();
  final sessionC = Get.find<SessionC>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Text(
          "Menu",
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (sessionC.role.value != 1)
            ListTile(
              onTap: () => homeC.changeTab(0, 'Home'),
              leading: const Icon(
                Icons.home_rounded,
              ),
              title: AppText.labelW600(
                "Home",
                14,
                Colors.black,
              ),
            ),
          if (sessionC.role.value == 1)
            ListTile(
              onTap: () => homeC.changeTab(1, 'Master Lokasi'),
              leading: const Icon(
                Icons.location_city_rounded,
              ),
              title: AppText.labelW600(
                "Master Lokasi",
                14,
                Colors.black,
              ),
            ),
          if (sessionC.role.value == 1)
            ListTile(
              onTap: () => homeC.changeTab(2, 'Rekap Absen'),
              leading: const Icon(
                Icons.document_scanner_rounded,
              ),
              title: AppText.labelW600(
                "Rekap Absen",
                14,
                Colors.black,
              ),
            ),
          ListTile(
            onTap: () async {
              // await FirebaseAuth.instance.signOut();
              await sessionC.clearSession();
              Get.offAllNamed(AppRouteName.auth);
            },
            leading: const Icon(
              Icons.logout_rounded,
            ),
            title: AppText.labelW600(
              "Keluar",
              14,
              Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
