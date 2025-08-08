// To parse this JSON data, do
//
//     final filterListModel = filterListModelFromJson(jsonString);

import 'dart:convert';

FilterListModel filterListModelFromJson(String str) => FilterListModel.fromJson(json.decode(str));

String filterListModelToJson(FilterListModel data) => json.encode(data.toJson());

class FilterListModel {
  String? status;
  String? message;
  DataFilterList? data;

  FilterListModel({
    this.status,
    this.message,
    this.data,
  });

  factory FilterListModel.fromJson(Map<String, dynamic> json) => FilterListModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : DataFilterList.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataFilterList {
  List<Type>? appType;
  List<Application>? applications;
  List<Type>? actorType;
  List<Application>? origins;
  List<Application>? genre;
  List<Application>? quality;
  List<Application>? languages;

  DataFilterList({
    this.appType,
    this.applications,
    this.actorType,
    this.origins,
    this.genre,
    this.quality,
    this.languages,
  });

  factory DataFilterList.fromJson(Map<String, dynamic> json) => DataFilterList(
    appType: json["app_type"] == null ? [] : List<Type>.from(json["app_type"]!.map((x) => Type.fromJson(x))),
    applications: json["applications"] == null ? [] : List<Application>.from(json["applications"]!.map((x) => Application.fromJson(x))),
    actorType: json["actor_type"] == null ? [] : List<Type>.from(json["actor_type"]!.map((x) => Type.fromJson(x))),
    origins: json["origins"] == null ? [] : List<Application>.from(json["origins"]!.map((x) => Application.fromJson(x))),
    genre: json["genre"] == null ? [] : List<Application>.from(json["genre"]!.map((x) => Application.fromJson(x))),
    quality: json["quality"] == null ? [] : List<Application>.from(json["quality"]!.map((x) => Application.fromJson(x))),
    languages: json["languages"] == null ? [] : List<Application>.from(json["languages"]!.map((x) => Application.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "app_type": appType == null ? [] : List<dynamic>.from(appType!.map((x) => x.toJson())),
    "applications": applications == null ? [] : List<dynamic>.from(applications!.map((x) => x.toJson())),
    "actor_type": actorType == null ? [] : List<dynamic>.from(actorType!.map((x) => x.toJson())),
    "origins": origins == null ? [] : List<dynamic>.from(origins!.map((x) => x.toJson())),
    "genre": genre == null ? [] : List<dynamic>.from(genre!.map((x) => x.toJson())),
    "quality": quality == null ? [] : List<dynamic>.from(quality!.map((x) => x.toJson())),
    "languages": languages == null ? [] : List<dynamic>.from(languages!.map((x) => x.toJson())),
  };
}

class Type {
  int? id;
  String? name;
  dynamic country;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? position;

  Type({
    this.id,
    this.name,
    this.country,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.position,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
    country: json["country"],
    status: statusValues.map[json["status"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country": country,
    "status": statusValues.reverse[status],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "position": position,
  };
}

enum Status {
  ACTIVE
}

final statusValues = EnumValues({
  "active": Status.ACTIVE
});

class Application {
  int? id;
  String? name;
  String? icon;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imageUrl;

  Application({
    this.id,
    this.name,
    this.icon,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    status: statusValues.map[json["status"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "status": statusValues.reverse[status],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_url": imageUrl,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}