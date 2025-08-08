// To parse this JSON data, do
//
//     final forgetPasswordModel = forgetPasswordModelFromJson(jsonString);

import 'dart:convert';

CommonModel forgetPasswordModelFromJson(String str) => CommonModel.fromJson(json.decode(str));

String forgetPasswordModelToJson(CommonModel data) => json.encode(data.toJson());

class CommonModel {
  int? status;
  String? message;

  CommonModel({
    this.status,
    this.message,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
