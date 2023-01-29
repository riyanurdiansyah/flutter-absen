import 'package:absensi_flutter/controllers/absen_c.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../utils/app_constanta.dart';

class AbsenPage extends StatelessWidget {
  const AbsenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aC = Get.find<AbsenC>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Absen",
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
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Obx(
              () => CupertinoSwitch(
                activeColor: Colors.teal[100],
                trackColor: Colors.grey.shade200,
                thumbColor: aC.isServiceEnabled.value
                    ? Colors.white
                    : Colors.grey.shade600,
                value: aC.isServiceEnabled.value,
                onChanged: (bool value) {
                  aC.listenLocation();
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (aC.isServiceEnabled.value) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: aC.fnStreamMasterLokasi(),
              builder: (ctx, snapshotMaster) {
                if (snapshotMaster.hasData) {
                  // aC.saveLocMaster(snapshotMaster.data);
                  return StreamBuilder<UserM>(
                    stream: aC.fnStreamUserById(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        // aC.saveUserById(snapshot.data!);
                        return FlutterMap(
                          mapController: aC.mapController,
                          options: MapOptions(
                            minZoom: aC.minZoom.value,
                            maxZoom: aC.maxZoom.value,
                            zoom: aC.zoom.value,
                            center: LatLng(
                                aC.user.value.lat ?? 0, aC.user.value.lng ?? 0),
                          ),
                          nonRotatedLayers: [
                            TileLayerOptions(
                              urlTemplate: mapBoxUrl,
                              additionalOptions: {
                                'access_token': mapBoxToken,
                                'id': mapBoxStyle,
                              },
                            ),
                            MarkerLayerOptions(
                              markers: List.generate(
                                1,
                                (index) => Marker(
                                  width: 30,
                                  height: 30,
                                  point: LatLng(
                                    aC.user.value.lat ?? 0,
                                    aC.user.value.lng ?? 0,
                                  ),
                                  builder: (_) => GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                      "assets/images/pin.png",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CircleLayerOptions(
                              circles: <CircleMarker>[
                                CircleMarker(
                                  point: LatLng(
                                      snapshotMaster.data!.data()!['lat'],
                                      snapshotMaster.data!.data()!['lng']),
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
                                  point: LatLng(
                                      snapshotMaster.data!.data()!['lat'],
                                      snapshotMaster.data!.data()!['lng']),
                                  builder: (_) => Image.asset(
                                    "assets/images/master.png",
                                  ),
                                ),
                              ],
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  width: 40,
                                  height: 40,
                                  point: LatLng(
                                    aC.user.value.lat ?? 0,
                                    aC.user.value.lng ?? 0,
                                  ),
                                  builder: (_) => Image.asset(
                                    "assets/images/pin.png",
                                  ),
                                ),
                              ],
                            ),
                          ],
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width,
                  child: SvgPicture.asset(
                    "assets/svg/map.svg",
                    width: 250,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Ooppss...",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  "Aktifkan lokasi terlebih dahulu",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        width: Get.width,
        child: Obx(
          () => aC.isServiceEnabled.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () async {
                              if (aC.args.value == 0) {
                                aC.scanBarcodeNormal(0);
                              } else {
                                aC.scanBarcodeNormal(1);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade400,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: Get.width,
                              height: 50,
                              child: Text(
                                aC.args.value == 0 ? "Checkin" : "Checkout",
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
