import 'package:absensi_flutter/models/user_m.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

abstract class HomeRepo {
  HomeRepo();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserById(String id);

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamMasterLokasi();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsenById(String id);

  Future saveMasterLocation(double lat, double lng);

  Future saveListenLocation(LocationData locationData, String id);

  Future<bool?> checkCheckinData(String id);

  Future<bool?> checkCheckoutData(String id);

  Future saveCheckin(String id, UserM user);

  Future saveCheckout(String id, UserM user);

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsensi();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUser();
}
