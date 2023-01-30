import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/models/absen_m.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/services/home_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminC extends GetxController {
  final _sessionC = Get.find<SessionC>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  final Rx<String> _tanggal = ''.obs;
  Rx<String> get tanggal => _tanggal;

  final RxList<AbsenM> _listAbsen = <AbsenM>[].obs;
  RxList<AbsenM> get listAbsen => _listAbsen;

  final RxList<AbsenM> _listAbsenAll = <AbsenM>[].obs;
  RxList<AbsenM> get listAbsenAll => _listAbsenAll;

  final _homeService = HomeService();

  final RxList<UserM> _listUser = <UserM>[].obs;
  RxList<UserM> get listUser => _listUser;

  @override
  void onInit() {
    super.onInit();
    tanggal.value = DateTime.now().toIso8601String();
  }

  void onTapDate(DateTime date) {
    _tanggal.value = date.toIso8601String();
    _listAbsen.value = _listAbsenAll
        .where(
          (e) =>
              DateTime.parse(e.date!).day == date.day &&
              DateTime.parse(e.date!).month == date.month &&
              DateTime.parse(e.date!).year == date.year,
        )
        .toList();
  }

  Stream<List<AbsenM>> fnStreamAbsensi() {
    final stream = _homeService.streamAbsenById(_sessionC.id.value);
    return stream.map((e) => e.docs).map((ev) {
      _listAbsen.clear();
      _listAbsenAll.clear();
      for (var data in ev) {
        _listAbsen.add(AbsenM.fromJson(data.data()));
        _listAbsenAll.add(AbsenM.fromJson(data.data()));
      }
      _listAbsen.value = _listAbsenAll
          .where(
            (e) =>
                DateTime.parse(e.date!).day ==
                    DateTime.parse(_tanggal.value).day &&
                DateTime.parse(e.date!).month ==
                    DateTime.parse(_tanggal.value).month &&
                DateTime.parse(e.date!).year ==
                    DateTime.parse(_tanggal.value).year,
          )
          .toList();

      return _listAbsen;
    });
  }

  void fnSaveAbsensi(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    _listAbsen.clear();
    _listAbsenAll.clear();
    for (var data in docs) {
      _listAbsen.add(AbsenM.fromJson(data.data()));
      _listAbsenAll.add(AbsenM.fromJson(data.data()));
    }
    _listAbsen.value = _listAbsenAll
        .where(
          (e) =>
              DateTime.parse(e.date!).day ==
                  DateTime.parse(_tanggal.value).day &&
              DateTime.parse(e.date!).month ==
                  DateTime.parse(_tanggal.value).month &&
              DateTime.parse(e.date!).year ==
                  DateTime.parse(_tanggal.value).year,
        )
        .toList();
  }

  Stream<List<UserM>> fnStreamUser() {
    final stream = _homeService.streamUser();
    return stream.map((e) => e.docs).map((ev) {
      _listUser.clear();
      for (var data in ev) {
        _listUser.add(UserM.fromJson(data.data()));
      }
      return _listUser;
    });
  }
}
