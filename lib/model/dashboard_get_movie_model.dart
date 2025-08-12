// To parse this JSON data, do
//
//     final dashboardGetMovieModel = dashboardGetMovieModelFromJson(jsonString);

import 'dart:convert';

DashboardGetMovieModel dashboardGetMovieModelFromJson(String str) => DashboardGetMovieModel.fromJson(json.decode(str));

String dashboardGetMovieModelToJson(DashboardGetMovieModel data) => json.encode(data.toJson());

class DashboardGetMovieModel {
  String? status;
  String? message;
  Data? data;

  DashboardGetMovieModel({
    this.status,
    this.message,
    this.data,
  });

  factory DashboardGetMovieModel.fromJson(Map<String, dynamic> json) => DashboardGetMovieModel(
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
  int? currentPage;
  List<DatumMovieList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<DatumMovieList>.from(json["data"]!.map((x) => DatumMovieList.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class AppTypeUrl {
  int? id;
  int? appId;
  int? movieId;
  String? price;
  String? appType;
  String? appUrl;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  DatumMovieList? movies;
  Application? application;

  AppTypeUrl({
    this.id,
    this.appId,
    this.movieId,
    this.price,
    this.appType,
    this.appUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.movies,
    this.application,
  });

  factory AppTypeUrl.fromJson(Map<String, dynamic> json) => AppTypeUrl(
    id: json["id"],
    appId: json["app_id"],
    movieId: json["movie_id"],
    price: json["price"],
    appType: json["app_type"]!,
    appUrl: json["app_url"],
    status: statusValues.map[json["status"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    movies: json["movies"] == null ? null : DatumMovieList.fromJson(json["movies"]),
    application: json["application"] == null ? null : Application.fromJson(json["application"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app_id": appId,
    "movie_id": movieId,
    "price": price,
    "app_type": appType,
    "app_url": appUrl,
    "status": statusValues.reverse[status],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "movies": movies?.toJson(),
    "application": application?.toJson(),
  };
}

class DatumMovieList {
  int? id;
  String? movieId;
  Country? country;
  String? origin;
  String? name;
  String? title;
  String? desc;
  String? genre;
  String? director;
  String? actor;
  String? bottScore;
  dynamic price;
  String? releasedAfter;
  String? language;
  Popularity? popularity;
  dynamic qualilty;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? genreName;
  String? actorName;
  List<AppTypeUrl>? firstSecondApp;
  Images? images;
  List<Images>? imagesAll;
  List<AppTypeUrl>? appTypeUrls;

  DatumMovieList({
    this.id,
    this.movieId,
    this.country,
    this.origin,
    this.name,
    this.title,
    this.desc,
    this.genre,
    this.director,
    this.actor,
    this.bottScore,
    this.price,
    this.releasedAfter,
    this.language,
    this.popularity,
    this.qualilty,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.genreName,
    this.actorName,
    this.firstSecondApp,
    this.images,
    this.imagesAll,
    this.appTypeUrls,
  });

  factory DatumMovieList.fromJson(Map<String, dynamic> json) => DatumMovieList(
    id: json["id"],
    movieId: json["movie_id"],
    country: countryValues.map[json["country"]]!,
    origin: json["origin"],
    name: json["name"],
    title: json["title"],
    desc: json["desc"],
    genre: json["genre"],
    director: json["director"],
    actor: json["actor"],
    bottScore: json["BOTT_score"],
    price: json["price"],
    releasedAfter: json["released_after"],
    language: json["language"],
    popularity: popularityValues.map[json["popularity"]]!,
    qualilty: json["qualilty"],
    status: statusValues.map[json["status"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    genreName: json["genre_name"],
    actorName: json["actor_name"],
    firstSecondApp: json["first_second_app"] == null ? [] : List<AppTypeUrl>.from(json["first_second_app"]!.map((x) => AppTypeUrl.fromJson(x))),
    images: json["images"] == null ? null : Images.fromJson(json["images"]),
    imagesAll: json["images_all"] == null ? [] : List<Images>.from(json["images_all"]!.map((x) => Images.fromJson(x))),
    appTypeUrls: json["app_type_urls"] == null ? [] : List<AppTypeUrl>.from(json["app_type_urls"]!.map((x) => AppTypeUrl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "movie_id": movieId,
    "country": countryValues.reverse[country],
    "origin": origin,
    "name": name,
    "title": title,
    "desc": desc,
    "genre": genre,
    "director": director,
    "actor": actor,
    "BOTT_score": bottScore,
    "price": price,
    "released_after": releasedAfter,
    "language": language,
    "popularity": popularityValues.reverse[popularity],
    "qualilty": qualilty,
    "status": statusValues.reverse[status],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "genre_name": genreName,
    "actor_name": actorName,
    "first_second_app": firstSecondApp == null ? [] : List<dynamic>.from(firstSecondApp!.map((x) => x.toJson())),
    "images": images?.toJson(),
    "images_all": imagesAll == null ? [] : List<dynamic>.from(imagesAll!.map((x) => x.toJson())),
    "app_type_urls": appTypeUrls == null ? [] : List<dynamic>.from(appTypeUrls!.map((x) => x.toJson())),
  };
}

enum AppType {
  ADDON,
  BUY,
  RENT,
  SUBSCRIPTION
}

final appTypeValues = EnumValues({
  "addon": AppType.ADDON,
  "buy": AppType.BUY,
  "rent": AppType.RENT,
  "subscription": AppType.SUBSCRIPTION
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

enum Name {
  APPLE_TV,
  MUBI,
  NETFLIX,
  PRIME_VIDEO
}

final nameValues = EnumValues({
  "Apple TV": Name.APPLE_TV,
  "Mubi": Name.MUBI,
  "Netflix": Name.NETFLIX,
  "Prime Video": Name.PRIME_VIDEO
});

enum Status {
  ACTIVE
}

final statusValues = EnumValues({
  "active": Status.ACTIVE
});

enum Country {
  INDIA
}

final countryValues = EnumValues({
  "India": Country.INDIA
});

class Images {
  int? id;
  int? movieId;
  Type? type;
  String? image;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Images({
    this.id,
    this.movieId,
    this.type,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    id: json["id"],
    movieId: json["movie_id"],
    type: typeValues.map[json["type"]]!,
    image: json["image"],
    status: statusValues.map[json["status"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "movie_id": movieId,
    "type": typeValues.reverse[type],
    "image": image,
    "status": statusValues.reverse[status],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Type {
  URL
}

final typeValues = EnumValues({
  "url": Type.URL
});

enum Popularity {
  MOST_POPULAR,
  POPULAR,
  VISITED_BY_DECENT_AMOUNT,
  VISITED_BY_FEWER
}

final popularityValues = EnumValues({
  "Most Popular": Popularity.MOST_POPULAR,
  "Popular": Popularity.POPULAR,
  "Visited by Decent Amount": Popularity.VISITED_BY_DECENT_AMOUNT,
  "Visited by fewer": Popularity.VISITED_BY_FEWER
});

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
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