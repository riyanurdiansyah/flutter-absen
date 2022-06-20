class UserM {
  UserM({
    this.createdAt,
    this.updatedAt,
    this.uid,
    this.email,
    this.handphone,
    this.lastLogin,
    this.name,
    this.username,
    this.profilePict,
    this.role,
    this.status,
    this.lat,
    this.lng,
    this.password,
  });

  String? createdAt;
  String? updatedAt;
  String? uid;
  String? email;
  String? handphone;
  String? lastLogin;
  String? name;
  String? username;
  String? profilePict;
  int? role;
  bool? status;
  double? lat;
  double? lng;
  String? password;

  factory UserM.fromJson(Map<String, dynamic> json) => UserM(
        createdAt: json["createdAt"] ?? DateTime.now().toIso8601String(),
        updatedAt: json["updatedAt"] ?? DateTime.now().toIso8601String(),
        uid: json["uid"],
        email: json["email"],
        handphone: json["handphone"] ?? '',
        name: json["name"] ?? '',
        username: json["username"],
        profilePict: json["profilePict"] ?? '',
        role: json["role"] ?? 2,
        status: json["status"] ?? true,
        lat: json["lat"] ?? 0.1,
        lng: json["lng"] ?? 0.1,
      );
}
