// To parse this JSON data, do
//
//     final signUpUserModel = signUpUserModelFromJson(jsonString);

import 'dart:convert';

SignUpUserModel signUpUserModelFromJson(String str) => SignUpUserModel.fromJson(json.decode(str));

String signUpUserModelToJson(SignUpUserModel data) => json.encode(data.toJson());

class SignUpUserModel {
  int? status;
  String? message;
  Data? data;

  SignUpUserModel({
    this.status,
    this.message,
    this.data,
  });

  factory SignUpUserModel.fromJson(Map<String, dynamic> json) => SignUpUserModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  AccessToken? accessToken;

  Data({
    this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"] == null ? null : AccessToken.fromJson(json["access_token"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken?.toJson(),
  };
}

class AccessToken {
  String? token;
  String? type;

  AccessToken({
    this.token,
    this.type,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
    token: json["token"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "type": type,
  };
}