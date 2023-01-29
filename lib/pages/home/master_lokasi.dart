import 'package:absensi_flutter/controllers/home_c.dart';
import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/utils/app_constanta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MasterLokasi extends StatefulWidget {
  const MasterLokasi({Key? key}) : super(key: key);

  @override
  State<MasterLokasi> createState() => _MasterLokasiState();
}

class _MasterLokasiState extends State<MasterLokasi> {
  final sessionC = Get.find<SessionC>();
  final homeC = Get.find<HomeC>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<UserM>(
        stream: homeC.fnStreamUserById(sessionC.id.value),
        builder: (context, snapshotUser) {
          if (snapshotUser.hasData) {
            // homeC.saveUser(snapshotUser.data);
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: homeC.fnStreamMasterLokasi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => Scaffold(
                      body: FlutterMap(
                        mapController: homeC.mapController,
                        options: MapOptions(
                          minZoom: homeC.minZoom.value,
                          maxZoom: homeC.maxZoom.value,
                          zoom: homeC.zoom.value,
                          center: LatLng(
                              snapshot.data!['lat'], snapshot.data!['lng']),
                          onTap: (tapPosition, latLng) {
                            homeC.onTapMasterLokasi(latLng);
                          },
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
                                color: Colors.blue.shade500.withOpacity(0.2),
                                borderStrokeWidth: 2,
                                useRadiusInMeter: true,
                                radius: 50,
                                borderColor: Colors.blue.shade200,
                              ),
                            ],
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 50,
                                height: 50,
                                point: LatLng(snapshot.data!.data()!['lat'],
                                    snapshot.data!.data()!['lng']),
                                builder: (_) => Image.asset(
                                  "assets/images/master.png",
                                  width: 15,
                                ),
                              ),
                            ],
                          ),
                          if (homeC.onTapMaster.value)
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  width: 40,
                                  height: 40,
                                  point: LatLng(
                                    homeC.latTemp.value,
                                    homeC.lngTemp.value,
                                  ),
                                  builder: (_) => Image.asset(
                                    "assets/images/pin.png",
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => homeC.onTapMaster.value
                                ? SizedBox(
                                    width: Get.width / 1.2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Card(
                                            elevation: 4,
                                            child: InkWell(
                                              onTap: () => homeC.removeOnTap(),
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  "HAPUS",
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Card(
                                            color: Colors.blue.shade300,
                                            elevation: 4,
                                            child: InkWell(
                                              onTap: () => homeC
                                                  .saveMasterLocationToDB(),
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  "SIMPAN",
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                          SizedBox(
                            width: Get.width / 1.2,
                            child: Card(
                              elevation: 4,
                              child: InkWell(
                                onTap: () => homeC.setCurrentLocMaster(),
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "SET MASTER CURRENT LOCATION",
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
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
      ),
    );
  }
}
