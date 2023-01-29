import 'dart:async';
import 'dart:math';
import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:absensi_flutter/services/home_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class AbsenC extends GetxController {
  final _sessionC = Get.find<SessionC>();
  final Rx<bool> _isServiceEnabled = false.obs;
  Rx<bool> get isServiceEnabled => _isServiceEnabled;

  StreamSubscription<LocationData>? _locationSub;
  Location location = Location();

  LocationData? locData;

  final _homeService = HomeService();

  MapController mapController = MapController();

  Rx<double> latMaster = 0.0.obs;
  Rx<double> lngMaster = 0.0.obs;

  Rx<double> minZoom = 16.0.obs;
  Rx<double> maxZoom = 20.0.obs;
  Rx<double> zoom = 18.0.obs;

  var args = 0.obs;

  final Rx<UserM> _user = UserM().obs;
  Rx<UserM> get user => _user;

  @override
  void onInit() {
    super.onInit();
    args.value = Get.arguments[0];
  }

  @override
  void onClose() {
    if (_locationSub != null) {
      _locationSub!.pause();
    }
    super.onClose();
  }

  void changeService() {
    _isServiceEnabled.value = !_isServiceEnabled.value;
  }

  Future<void> listenLocation() async {
    _isServiceEnabled.value = !_isServiceEnabled.value;
    location.requestPermission().then((status) {
      if (status == PermissionStatus.granted) {
        if (_isServiceEnabled.value) {
          _locationSub =
              location.onLocationChanged.listen((locationData) async {
            await _homeService.saveListenLocation(
                locationData, _sessionC.id.value);
            mapController.move(
                LatLng(locationData.latitude!, locationData.longitude!), 18);
          });
        } else {
          mapController = MapController();
          _locationSub!.pause();
        }
      }
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamMasterLokasi() {
    final stream = _homeService.streamMasterLokasi();

    return stream.map((data) {
      latMaster.value = data.data()!['lat'];
      lngMaster.value = data.data()!['lng'];

      return data;
    });
  }

  // Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamUserById() {
  //   return _homeService.streamUserById();
  // }

  Stream<UserM> fnStreamUserById() {
    final stream = _homeService.streamUserById(_sessionC.id.value);
    return stream.map((event) {
      _user.value = UserM.fromJson(event.data()!);
      return _user.value;
    });
  }

  // void saveLocMaster(DocumentSnapshot<Map<String, dynamic>>? data) {
  //   latMaster.value = data!.data()!['lat'];
  //   lngMaster.value = data.data()!['lng'];
  // }

  // void saveUserById(DocumentSnapshot<Map<String, dynamic>>? data) {
  //   user.value = UserM.fromJson(data!.data()!);
  // }

  Future<void> scanBarcodeNormal(int flag) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes.toLowerCase() == 'absen') {}
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes.toLowerCase() == 'absen' && flag == 0) {
      fnCheckCheckin();
    } else if (barcodeScanRes.toLowerCase() == 'absen' && flag == 1) {
      fnCheckCheckout();
    } else {
      AppDialog.dialogWithRoute(
        "Ooppss..",
        "Silahkan scan qr code yang sudah ditentukan",
      );
    }
  }

  void calculateDistance() {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latMaster - user.value.lat!) * p) / 2 +
        c(user.value.lat! * p) *
            c(latMaster * p) *
            (1 - c((lngMaster - user.value.lng!) * p)) /
            2;
    var hasil = (12742 * asin(sqrt(a))) * 1000;
    if (hasil > 25) {
      AppDialog.dialogWithRoute(
        "Ooppss..",
        "Jarak maksimal adalah 25 Meter untuk melakukan absen",
      );
    } else {
      AppDialog.dialogConfirmCheckin(user.value);
    }
  }

  Future fnCheckCheckout() async {
    final response = await _homeService.checkCheckoutData(_sessionC.id.value);
    if (response!) {
      calculateDistance();
    } else {
      AppDialog.dialogWithRoute("Ooppss...", "Kamu sudah checkout hari ini");
    }
  }

  void fnCheckCheckin() async {
    final response = await _homeService.checkCheckinData(_sessionC.id.value);
    if (response!) {
      calculateDistance();
    } else {
      AppDialog.dialogWithRoute("Ooppss...", "Kamu sudah checkin hari ini");
    }
  }

  void fnSaveCheckin(UserM user) {
    _homeService.saveCheckin(_sessionC.id.value, user);
    Get.back();
  }

  void fnSaveCheckout(UserM user) {
    _homeService.saveCheckout(_sessionC.id.value, user);
    Get.back();
  }
}
