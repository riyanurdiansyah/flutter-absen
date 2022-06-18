import 'package:absensi_flutter/models/absen_m.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/services/home_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeC extends GetxController {
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
  }

  void changeTab(int i) {
    _indexTab.value = i;
    Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamMasterLokasi() {
    return _homeService.streamMasterLokasi();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamUserById(String id) {
    return _homeService.streamUserById();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fnStreamAbsenById() {
    return _homeService.streamAbsenById();
  }

  void saveUser(DocumentSnapshot<Map<String, dynamic>>? data) {
    _user.value = UserM.fromJson(data!.data()!);
  }

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

  void setCurrentLocMaster() {
    latTemp.value = user.value.lat!;
    lngTemp.value = user.value.lng!;
    saveMasterLocationToDB();
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
