import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KaryawanPage extends StatelessWidget {
  const KaryawanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeC>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Get.height,
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: homeC.fnStreamLokasiKaryawan(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              homeC.saveListKaryawan(snapshot.data!.docs);
              return AzListView(
                data: homeC.listAZ,
                itemCount: homeC.listKaryawan.length,
                itemBuilder: (_, i) => ListTile(
                  subtitle: AppText.labelBold(
                    homeC.listKaryawan[i].name!,
                    14,
                    Colors.black,
                  ),
                  title: AppText.labelW600(
                    homeC.listKaryawan[i].username!,
                    14,
                    Colors.grey.shade400,
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
