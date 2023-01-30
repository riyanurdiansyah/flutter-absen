import 'dart:developer';

import 'package:absensi_flutter/models/regist_m.dart';
import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/repositories/home_repo.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

class HomeService extends HomeRepo {
  //final _sC = Get.find<SessionC>();
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamMasterLokasi() {
    return FirebaseFirestore.instance
        .collection("/master")
        .doc("lokasi")
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserById(
    String id,
  ) {
    return FirebaseFirestore.instance.collection("users").doc(id).snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsenById(String id) {
    return FirebaseFirestore.instance
        .collection("/absen")
        .where("id", isEqualTo: id)
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
    String id,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('/users').doc(id).update(
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
  Future<bool?> checkCheckinData(String id) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('absen')
          .where(
            'id',
            isEqualTo: id,
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
  Future<bool?> checkCheckoutData(String id) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('absen')
          .where(
            'id',
            isEqualTo: id,
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
  Future saveCheckin(String id, UserM user) async {
    final body = {
      "id": id,
      "image": "-",
      "date": DateTime.now().toIso8601String(),
      "timeIn": DateTime.now().toIso8601String(),
      "timeOut": "-",
      "remote": false,
      "name": user.name,
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
  Future saveCheckout(String id, UserM user) async {
    final body = {
      "timeOut": DateTime.now().toIso8601String(),
      "latCheckout": user.lat,
      "lngCheckout": user.lng,
    };
    try {
      final response = await FirebaseFirestore.instance
          .collection("/absen")
          .where("id", isEqualTo: id)
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
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUser() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: 2)
        .snapshots();
  }

  @override
  Future<RegistM> registerWithEmail(UserM user, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
      if (credential.user != null) {
        user.uid = credential.user!.uid;
        saveUserToTable(user);
        return RegistM(status: true, message: "Registrasi berhasil");
      } else {
        return RegistM(
            status: false, message: "Gagal registrasi silahkan coba lagi");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return RegistM(status: false, message: "Password terlalu lemah");
      } else if (e.code == 'email-already-in-use') {
        return RegistM(status: false, message: "Email sudah terdaftar");
      }
      return RegistM(
          status: false, message: "Terjadi kesalah silahkan coba lagi...");
    } catch (e) {
      return RegistM(
          status: false, message: "Terjadi kesalah silahkan coba lagi...");
    }
  }

  @override
  Future<void> saveUserToTable(UserM user) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid!)
          .set(user.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
