// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  String? status;
  String? message;
  List<DatumCountry>? data;

  CountryModel({
    this.status,
    this.message,
    this.data,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DatumCountry>.from(json["data"]!.map((x) => DatumCountry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DatumCountry {
  int? id;
  String? countryName;
  String? countryCode;
  String? countryFlag;
  String? currencyName;
  String? currencyCode;
  String? currencySymbol;
  String? prefixSuffix;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  DatumCountry({
    this.id,
    this.countryName,
    this.countryCode,
    this.countryFlag,
    this.currencyName,
    this.currencyCode,
    this.currencySymbol,
    this.prefixSuffix,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory DatumCountry.fromJson(Map<String, dynamic> json) => DatumCountry(
    id: json["id"],
    countryName: json["country_name"],
    countryCode: json["country_code"],
    countryFlag: json["country_flag"],
    currencyName: json["currency_name"],
    currencyCode: json["currency_code"],
    currencySymbol: json["currency_symbol"],
    prefixSuffix: json["prefix_suffix"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_name": countryName,
    "country_code": countryCode,
    "country_flag": countryFlag,
    "currency_name": currencyName,
    "currency_code": currencyCode,
    "currency_symbol": currencySymbol,
    "prefix_suffix": prefixSuffix,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
