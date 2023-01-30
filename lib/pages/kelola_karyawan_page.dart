import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_c.dart';

class KelolaKaryawanPage extends StatelessWidget {
  KelolaKaryawanPage({Key? key}) : super(key: key);

  final admC = Get.find<AdminC>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<List<UserM>>(
        stream: admC.fnStreamUser(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (_, index) {
                final data = snapshot.data![index];
                return ListTile(
                  leading: data.profilePict!.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 35,
                            color: Colors.grey.shade500,
                          ),
                        )
                      : Image.network(data.profilePict!),
                  title: AppText.labelW600(
                    data.name!,
                    14,
                    Colors.black,
                  ),
                  subtitle: AppText.labelW600(
                    data.email!,
                    12,
                    Colors.grey.shade500,
                  ),
                );
              },
            );
          }
          return Center(
            child: AppText.labelW500(
              "Tidak ada data user",
              14,
              Colors.grey.shade600,
            ),
          );
        }),
      ),
    );
  }
}
