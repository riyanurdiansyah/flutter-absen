import '../models/user_m.dart';

abstract class AuthRepo {
  Future signin(String email, password);

  Future<UserM?> getInfoUser(String uid);

  Future<String?> getEmail(String username);
}
