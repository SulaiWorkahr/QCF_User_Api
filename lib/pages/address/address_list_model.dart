// To parse this JSON data, do
//
//     final addressListmodel = addressListmodelFromJson(jsonString);

import 'dart:convert';

AddressListmodel addressListmodelFromJson(String str) =>
    AddressListmodel.fromJson(json.decode(str));

String addressListmodelToJson(AddressListmodel data) =>
    json.encode(data.toJson());

class AddressListmodel {
  String status;
  String code;
  List<AddressList> list;
  String message;

  AddressListmodel({
    required this.status,
    required this.code,
    required this.list,
    required this.message,
  });

  factory AddressListmodel.fromJson(Map<String, dynamic> json) =>
      AddressListmodel(
        status: json["status"],
        code: json["code"],
        list: List<AddressList>.from(
            json["list"].map((x) => AddressList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "message": message,
      };
}

class AddressList {
  int id;
  int? defaultAddress;
  String? type;
  int? userId;
  String? address;
  String? addressLine2;
  String? city;
  String? state;
  int? country;
  int? postcode;
  String? landmark;
  int? status;
  int? createdBy;
  DateTime? createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  AddressList({
    required this.id,
    this.defaultAddress,
    this.type,
    this.userId,
    this.address,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.landmark,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["id"],
        defaultAddress: json["default_address"],
        type: json["type"],
        userId: json["user_id"],
        address: json["address"],
        addressLine2: json["address_line_2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postcode: json["postcode"],
        landmark: json["landmark"],
        status: json["status"],
        // createdBy: json["created_by"],
        // createdDate: json["created_date"] == null
        //     ? null
        //     : DateTime.parse(json["created_date"]),
        // updatedBy: json["updated_by"],
        // updatedDate: json["updated_date"] == null
        //     ? null
        //     : DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "default_address": defaultAddress,
        "type": type,
        "user_id": userId,
        "address": address,
        "address_line_2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "postcode": postcode,
        "landmark": landmark,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate!.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate!.toIso8601String(),
      };
}