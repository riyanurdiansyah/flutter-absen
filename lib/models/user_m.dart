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

  factory UserM.fromJson(Map<String, dynamic> json) => UserM(
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
        email: json["email"],
        handphone: json["handphone"],
        name: json["name"],
        username: json["username"],
        profilePict: json["profilePict"],
        role: json["role"],
        status: json["status"],
        lat: json["lat"],
        lng: json["lng"],
      );
}
