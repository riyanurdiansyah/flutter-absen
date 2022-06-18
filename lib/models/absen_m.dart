class AbsenM {
  AbsenM({
    this.timeIn,
    this.timeOut,
    this.id,
    this.image,
    this.latCheckin,
    this.lngCheckin,
    this.latCheckout,
    this.lngCheckout,
    this.name,
    this.date,
  });

  String? timeIn;
  String? timeOut;
  String? id;
  String? image;
  double? latCheckin;
  double? lngCheckin;
  double? latCheckout;
  double? lngCheckout;
  String? name;
  String? date;

  factory AbsenM.fromJson(Map<String, dynamic> json) => AbsenM(
        timeIn: json["timeIn"],
        timeOut: json["timeOut"],
        id: json["id"],
        image: json["image"],
        latCheckin: json["latCheckin"],
        lngCheckin: json["lngCheckin"],
        latCheckout: json["latCheckout"],
        lngCheckout: json["lngCheckout"],
        name: json["name"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "timeIn": timeIn,
        "timeOut": timeOut,
        "id": id,
        "image": image,
        "latCheckin": latCheckin,
        "lngCheckin": lngCheckin,
        "latCheckout": latCheckout,
        "lngCheckout": lngCheckout,
        "name": name,
        "date": date,
      };
}
