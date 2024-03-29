import 'dart:convert';

import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/models/absen_m.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/services/home_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeC extends GetxController {
  final _sessionC = Get.find<SessionC>();
  final Rx<int> _indexTab = 0.obs;
  Rx<int> get indexTab => _indexTab;

  final Rx<UserM> _user = UserM().obs;
  Rx<UserM> get user => _user;

  final _homeService = HomeService();

  MapController mapController = MapController();

  final Rx<double> _minZoom = 16.0.obs;
  Rx<double> get minZoom => _minZoom;

  final Rx<double> _maxZoom = 20.0.obs;
  Rx<double> get maxZoom => _maxZoom;

  final Rx<double> _zoom = 17.0.obs;
  Rx<double> get zoom => _zoom;

  final Rx<double> _latTemp = 0.0.obs;
  Rx<double> get latTemp => _latTemp;

  final Rx<double> _lngTemp = 0.0.obs;
  Rx<double> get lngTemp => _lngTemp;

  final Rx<bool> _onTapMaster = false.obs;
  Rx<bool> get onTapMaster => _onTapMaster;

  final Rx<bool> _isServiceEnabled = false.obs;
  Rx<bool> get isServiceEnabled => _isServiceEnabled;

  final Rx<String> _uid = ''.obs;
  Rx<String> get uid => _uid;

  final Rx<String> _title = 'Home'.obs;
  Rx<String> get title => _title;

  final RxList<AbsenM> _listAbsen = <AbsenM>[].obs;
  RxList<AbsenM> get listAbsen => _listAbsen;

  final Rx<double> _persentase = 0.0.obs;
  Rx<double> get persentase => _persentase;

  final RxList<AbsenM> _listRekap = <AbsenM>[].obs;
  RxList<AbsenM> get listRekap => _listRekap;

  late SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    _uid.value = prefs.getString('uid') ?? '';
    if (_sessionC.role.value == 1) {
      _indexTab.value = 1;
      _title.value = "Master Lokasi";
    }
  }

  void changeTab(int i, String txt) {
    _indexTab.value = i;
    _title.value = txt;
    Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamMasterLokasi() {
    return _homeService.streamMasterLokasi();
  }

  Stream<UserM> fnStreamUserById(String id) {
    final stream = _homeService.streamUserById(_sessionC.id.value);
    return stream.map((event) {
      _user.value = UserM.fromJson(event.data()!);
      return _user.value;
    });
  }

  Stream<List<AbsenM>> fnStreamAbsenById() {
    final stream = _homeService.streamAbsenById();
    return stream.map((e) => e.docs).map((ev) {
      _listAbsen.value =
          absentFromJson(json.encode(ev.map((data) => data.data()).toList()));
      return _listAbsen;
    });
  }

  // void saveUser(DocumentSnapshot<Map<String, dynamic>>? data) {
  //   _user.value = UserM.fromJson(data!.data()!);
  // }

  void onTapMasterLokasi(LatLng latLngOnTap) {
    _latTemp.value = latLngOnTap.latitude;
    _lngTemp.value = latLngOnTap.longitude;
    _onTapMaster.value = true;
  }

  void removeOnTap() {
    _onTapMaster.value = false;
  }

  void saveMasterLocationToDB() {
    _homeService.saveMasterLocation(latTemp.value, lngTemp.value);
    changeCamera();
    removeOnTap();
  }

  void changeCamera() {
    mapController.move(LatLng(_latTemp.value, _lngTemp.value), 17);
  }

  void setCurrentLocMaster() async {
    final loc = await _determinePosition();
    latTemp.value = loc.latitude;
    lngTemp.value = loc.longitude;
    saveMasterLocationToDB();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void saveAbsen(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    _listAbsen.clear();
    for (var data in docs) {
      _listAbsen.add(AbsenM.fromJson(data.data()));
    }
    _listAbsen.sort(
      (a, b) => b.date!.compareTo(
        a.date!,
      ),
    );
  }

  void saveRekap(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    _listRekap.clear();
    final absensiBulan = docs
        .where((e) => DateTime.parse(e['date']).month == DateTime.now().month)
        .toList();
    if (absensiBulan.isNotEmpty) {
      for (var data in absensiBulan) {
        _listRekap.add(AbsenM.fromJson(data.data()));
      }
      final underNine =
          _listRekap.where((e) => DateTime.parse(e.timeIn!).hour < 9).toList();
      final atNine = _listRekap
          .where((e) =>
              DateTime.parse(e.timeIn!).hour == 9 &&
              DateTime.parse(e.timeIn!).minute <= 15)
          .toList();
      _persentase.value =
          ((underNine.length + atNine.length) / _listRekap.length) * 100;
    } else {
      _persentase.value = 0;
    }
  }
}
