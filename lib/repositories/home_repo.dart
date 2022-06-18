import 'package:absensi_flutter/models/user_m.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

abstract class HomeRepo {
  HomeRepo();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserById();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamMasterLokasi();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsenById();

  Future saveMasterLocation(double lat, double lng);

  Future saveListenLocation(LocationData locationData);

  Future<bool?> checkCheckinData();

  Future<bool?> checkCheckoutData();

  Future saveCheckin(UserM user);

  Future saveCheckout(UserM user);
}
