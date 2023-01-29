import 'dart:convert';

import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/models/absen_m.dart';
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
      _listAbsen.value =
          absentFromJson(json.encode(ev.map((data) => data.data()).toList()));
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
}
