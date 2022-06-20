import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:absensi_flutter/utils/app_constanta.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LokasiKaryawanPage extends StatelessWidget {
  const LokasiKaryawanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeC>();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: homeC.fnStreamLokasiKaryawan(),
      builder: (context, snapshotUser) {
        if (snapshotUser.hasData) {
          homeC.saveLokasiKaryawan(snapshotUser.data!.docs);
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: homeC.fnStreamMasterLokasi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Obx(
                  () => Scaffold(
                    body: FlutterMap(
                      options: MapOptions(
                        minZoom: homeC.minZoom.value,
                        maxZoom: homeC.maxZoom.value,
                        zoom: homeC.zoom.value,
                        center: LatLng(
                          snapshot.data!['lat'],
                          snapshot.data!['lng'],
                        ),
                      ),
                      nonRotatedLayers: [
                        TileLayerOptions(
                          urlTemplate: mapBoxUrl,
                          additionalOptions: {
                            'access_token': mapBoxToken,
                            'id': mapBoxStyle,
                          },
                        ),
                        CircleLayerOptions(
                          circles: <CircleMarker>[
                            CircleMarker(
                              point: LatLng(snapshot.data!.data()!['lat'],
                                  snapshot.data!.data()!['lng']),
                              color: Colors.lightBlue.shade300.withOpacity(0.4),
                              borderStrokeWidth: 2,
                              useRadiusInMeter: true,
                              radius: 60,
                              borderColor: Colors.lightBlue.shade200,
                            ),
                          ],
                        ),
                        MarkerLayerOptions(
                          markers: List.generate(
                            homeC.listLokKaryawan.length,
                            (i) => Marker(
                              point: LatLng(
                                homeC.listLokKaryawan[i].lat!,
                                homeC.listLokKaryawan[i].lng!,
                              ),
                              builder: (_) => GestureDetector(
                                onTap: () => AppDialog.bottomSheetUser(
                                    homeC.listLokKaryawan[i]),
                                child: Image.asset(
                                  "assets/images/mark.webp",
                                  width: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              width: 50,
                              height: 50,
                              point: LatLng(snapshot.data!.data()!['lat'],
                                  snapshot.data!.data()!['lng']),
                              builder: (_) => SizedBox(
                                width: 10,
                                child: Image.asset(
                                  "assets/images/master.png",
                                  width: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
    );
  }
}
