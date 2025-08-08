// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? status;
  String? message;
  DataProfile? data;

  ProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : DataProfile.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataProfile {
  int? id;
  String? role;
  String? firstName;
  String? lastName;
  String? email;
  int? otp;
  int? otpVerifyStatus;
  String? mobileNo;
  String? address;
  String? age;
  String? gender;
  String? profilePic;
  int? countryIn;
  int? countryBorn;
  String? username;
  String? loginType;
  String? socialId;
  String? status;
  String? deviceType;
  String? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profileImageUrl;

  DataProfile({
    this.id,
    this.role,
    this.firstName,
    this.lastName,
    this.email,
    this.otp,
    this.otpVerifyStatus,
    this.mobileNo,
    this.address,
    this.age,
    this.gender,
    this.profilePic,
    this.countryIn,
    this.countryBorn,
    this.username,
    this.loginType,
    this.socialId,
    this.status,
    this.deviceType,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
  });

  factory DataProfile.fromJson(Map<String, dynamic> json) => DataProfile(
    id: json["id"],
    role: json["role"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    otp: json["otp"],
    otpVerifyStatus: json["otp_verify_status"],
    mobileNo: json["mobile_no"],
    address: json["address"],
    age: json["age"],
    gender: json["gender"],
    profilePic: json["profile_pic"],
    countryIn: json["country_in"],
    countryBorn: json["country_born"],
    username: json["username"],
    loginType: json["login_type"],
    socialId: json["social_id"],
    status: json["status"],
    deviceType: json["device_type"],
    deviceToken: json["device_token"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    profileImageUrl: json["profile_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "otp": otp,
    "otp_verify_status": otpVerifyStatus,
    "mobile_no": mobileNo,
    "address": address,
    "age": age,
    "gender": gender,
    "profile_pic": profilePic,
    "country_in": countryIn,
    "country_born": countryBorn,
    "username": username,
    "login_type": loginType,
    "social_id": socialId,
    "status": status,
    "device_type": deviceType,
    "device_token": deviceToken,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "profile_image_url": profileImageUrl,
  };
}