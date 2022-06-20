import 'package:absensi_flutter/controllers/session_c.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/repositories/home_repo.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class HomeService extends HomeRepo {
  final _sC = Get.find<SessionC>();
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamMasterLokasi() {
    return FirebaseFirestore.instance
        .collection("/master")
        .doc("lokasi")
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserById() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_sC.id.value)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsenById() {
    return FirebaseFirestore.instance
        .collection("/absen")
        .where("id", isEqualTo: _sC.id.value)
        .snapshots();
  }

  @override
  Future saveMasterLocation(double lat, double lng) async {
    final body = {
      "lat": lat,
      "lng": lng,
    };
    try {
      await FirebaseFirestore.instance
          .collection("/master")
          .doc("lokasi")
          .update(body);
      AppDialog.dialogWithRoute("Berhasil", "Master Lokasi Berhasil Diubah");
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Future saveListenLocation(
    LocationData locationData,
  ) async {
    print('id : ${_sC.id.value}');
    try {
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_sC.id.value)
          .update(
        {
          "lat": locationData.latitude,
          "lng": locationData.longitude,
          "updatedAt": DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Future<bool?> checkCheckinData() async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('absen')
          .where(
            'id',
            isEqualTo: _sC.id.value,
          )
          .get();

      final data = response.docs
          .where((e) =>
              DateTime.parse(e['date']).year == DateTime.now().year &&
              DateTime.parse(e['date']).month == DateTime.now().month &&
              DateTime.parse(e['date']).day == DateTime.now().day)
          .toList();

      if (data.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return false;
    }
  }

  @override
  Future<bool?> checkCheckoutData() async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('absen')
          .where(
            'id',
            isEqualTo: _sC.id.value,
          )
          .get();

      final data = response.docs
          .where((e) =>
              DateTime.parse(e['date']).year == DateTime.now().year &&
              DateTime.parse(e['date']).month == DateTime.now().month &&
              DateTime.parse(e['date']).day == DateTime.now().day)
          .toList();

      if (data.isNotEmpty) {
        if (data[0]['timeOut'] != "-") {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return false;
    }
  }

  @override
  Future saveCheckin(UserM user) async {
    final body = {
      "id": _sC.id.value,
      "image": "-",
      "date": DateTime.now().toIso8601String(),
      "timeIn": DateTime.now().toIso8601String(),
      "timeOut": "-",
      "remote": false,
      "name": _sC.name.value,
      "latCheckin": user.lat,
      "lngCheckin": user.lng,
    };
    AppDialog.dialogWithRoute("Berhasil", "Absen sudah direkam");
    try {
      await FirebaseFirestore.instance.collection("/absen").add(body);
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Future saveCheckout(UserM user) async {
    final body = {
      "timeOut": DateTime.now().toIso8601String(),
      "latCheckout": user.lat,
      "lngCheckout": user.lng,
    };
    try {
      final response = await FirebaseFirestore.instance
          .collection("/absen")
          .where("id", isEqualTo: _sC.id.value)
          .get();

      final data = response.docs
          .where((e) =>
              DateTime.parse(e['date']).year == DateTime.now().year &&
              DateTime.parse(e['date']).month == DateTime.now().month &&
              DateTime.parse(e['date']).day == DateTime.now().day)
          .toList();
      await FirebaseFirestore.instance
          .collection("/absen")
          .doc(data[0].id)
          .update(body);
      AppDialog.dialogWithRoute("Berhasil", "Absen sudah direkam");
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsensi() {
    return FirebaseFirestore.instance.collection("absen").snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLokasiKaryawan() {
    return FirebaseFirestore.instance
        .collection("users")
        .where('role', isNotEqualTo: 1)
        .snapshots();
  }

  @override
  Future<bool> addKaryawan(UserM user) async {
    try {
      final response =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      final body = {
        "uid": response.user!.uid,
        "email": user.email,
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
        "lat": user.lat,
        "lng": user.lng,
        "name": user.name,
        "profilePict": '',
        "role": user.role,
        "status": true,
        "username": user.username,
        "handphone": user.handphone,
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(response.user!.uid)
          .set(body);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppDialog.dialogWithRoute('Ooppss...', 'Password terlalu lemah');
        return false;
      } else if (e.code == 'email-already-in-use') {
        AppDialog.dialogWithRoute('Ooppss...', 'Email sudah terdaftar');
        return false;
      } else {
        AppDialog.dialogWithRoute('Ooppss...', '${e.message}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
