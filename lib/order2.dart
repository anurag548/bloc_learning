// To parse this JSON data, do
//
//     final order2 = order2FromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Order2 order2FromJson(String str) => Order2.fromJson(json.decode(str));

String order2ToJson(Order2 data) => json.encode(data.toJson());

class Order2 {
  Order2({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  int statusCode;
  bool status;
  String message;
  List<Datum> data;

  factory Order2.fromJson(Map<String, dynamic> json) => Order2(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.orderNumber,
    required this.isActive,
    required this.picture,
    required this.paymentMode,
    required this.orderstatus,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.deliveryPincode,
  });

  int orderNumber;
  bool isActive;
  String picture;
  PaymentMode paymentMode;
  Orderstatus orderstatus;
  String name;
  String email;
  String phone;
  String address;
  int deliveryPincode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderNumber: json["order_number"],
        isActive: json["isActive"],
        picture: json["picture"],
        paymentMode: paymentModeValues.map[json["payment_mode"]]!,
        orderstatus: orderstatusValues.map[json["orderstatus"]]!,
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        deliveryPincode: json["delivery_pincode"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "isActive": isActive,
        "picture": picture,
        "payment_mode": paymentModeValues.reverse[paymentMode],
        "orderstatus": orderstatusValues.reverse[orderstatus],
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "delivery_pincode": deliveryPincode,
      };
}

enum Orderstatus { NOT_PICKED, PENDING, UNDELIVERED }

final orderstatusValues = EnumValues({
  "NOT PICKED": Orderstatus.NOT_PICKED,
  "PENDING": Orderstatus.PENDING,
  "UNDELIVERED": Orderstatus.UNDELIVERED
});

enum PaymentMode { COD, ONLINE }

final paymentModeValues =
    EnumValues({"COD": PaymentMode.COD, "online": PaymentMode.ONLINE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
