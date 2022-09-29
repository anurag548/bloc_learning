// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderList,
  });

  List<OrderList> orderList;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderList: List<OrderList>.from(
            json["OrderList"].map((x) => OrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
      };
}

class OrderList {
  OrderList({
    required this.orderNumber,
    required this.orderedBy,
    required this.orderStatus,
    required this.orderValue,
    required this.creditValue,
    required this.couponValue,
    required this.amountPaid,
    required this.date,
    required this.mode,
    required this.shipping,
    required this.prescriptionStatus,
    required this.paymentMode,
    required this.transactionNo,
    required this.orderCreatedBy,
  });

  String orderNumber;
  String orderedBy;
  OrderStatus? orderStatus;
  String orderValue;
  Value? creditValue;
  Value? couponValue;
  String amountPaid;
  String date;
  Mode? mode;
  String shipping;
  PrescriptionStatus? prescriptionStatus;
  String paymentMode;
  String transactionNo;
  String orderCreatedBy;

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        orderNumber: json["Order Number"],
        orderedBy: json["Ordered By"],
        orderStatus: orderStatusValues.map[json["Order Status"]],
        orderValue: json["Order Value"],
        creditValue: valueValues.map[json["Credit value"]],
        couponValue: valueValues.map[json["Coupon Value"]],
        amountPaid: json["Amount Paid"],
        date: json["Date"],
        mode: modeValues.map[json["Mode"]],
        shipping: json["Shipping"],
        prescriptionStatus:
            prescriptionStatusValues.map[json["Prescription Status"]],
        paymentMode: json["Payment Mode"],
        transactionNo: json["Transaction No"],
        orderCreatedBy: json["Order Created By"],
      );

  Map<String, dynamic> toJson() => {
        "Order Number": orderNumber,
        "Ordered By": orderedBy,
        "Order Status": orderStatusValues.reverse[orderStatus],
        "Order Value": orderValue,
        "Credit value": valueValues.reverse[creditValue],
        "Coupon Value": valueValues.reverse[couponValue],
        "Amount Paid": amountPaid,
        "Date": date,
        "Mode": modeValues.reverse[mode],
        "Shipping": shipping,
        "Prescription Status":
            prescriptionStatusValues.reverse[prescriptionStatus],
        "Payment Mode": paymentMode,
        "Transaction No": transactionNo,
        "Order Created By": orderCreatedBy,
      };
}

enum Value { THE_000, EMPTY }

final valueValues = EnumValues({"-": Value.EMPTY, "0.00": Value.THE_000});

enum Mode { ONLINE_BACKEND, WEB, MOBILE }

final modeValues = EnumValues({
  "MOBILE": Mode.MOBILE,
  "online-backend": Mode.ONLINE_BACKEND,
  "WEB": Mode.WEB
});

enum OrderStatus { PENDING }

final orderStatusValues = EnumValues({"PENDING": OrderStatus.PENDING});

enum PrescriptionStatus { COMPLETED, PENDING, EMPTY }

final prescriptionStatusValues = EnumValues({
  "Completed": PrescriptionStatus.COMPLETED,
  "-": PrescriptionStatus.EMPTY,
  "Pending": PrescriptionStatus.PENDING
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => MapEntry(v, k));
    }
    return reverseMap!;
  }
}
