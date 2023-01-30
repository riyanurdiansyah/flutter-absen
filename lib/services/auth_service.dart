import 'package:absensi_flutter/models/user_m.dart';
import 'package:absensi_flutter/repositories/auth_repo.dart';
import 'package:absensi_flutter/utils/app_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends AuthRepo {
  @override
  Future<UserM?> getInfoUser(String uid) async {
    try {
      final response =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final responseJson = response.data() as Map<String, dynamic>;
      return UserM.fromJson(responseJson);
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    }
  }

  @override
  Future signin(String email, password) async {
    try {
      final res = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password!);
      return res.user!.uid;
    } on FirebaseAuthException catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    }
  }

  @override
  Future<String?> getEmail(String username) async {
    try {
      final res = await FirebaseFirestore.instance
          .collection('/users')
          .where('username', isEqualTo: username)
          .get();

      return res.docs[0]['email'];
    } on FirebaseAuthException catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    }
  }
}
