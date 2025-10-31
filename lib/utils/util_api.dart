import 'dart:convert';
import 'dart:math';
import 'package:bott/model/common_model.dart';
import 'package:bott/model/country_model.dart';
import 'package:bott/model/dashboard_get_movie_model.dart';
import 'package:bott/model/filter_list_model.dart';
import 'package:bott/model/forget_password_model.dart';
import 'package:bott/model/login_user_model.dart';
import 'package:bott/model/profile_model.dart';
import 'package:bott/model/sign_up_user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';

import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'helper_save_data.dart';

class UtilApi {
  static Future<bool> checkNetwork() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  static String getPlatformName() {
    if (kIsWeb) {
      return "web";
    } else if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else {
      return "unknown";
    }
  }

  static Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static String baseUrl = "https://playnemo.com/api/";
  static String signupApi = "${baseUrl}signup";
  static String loginApi = "${baseUrl}login";
  static String forgotPasswordApi = "${baseUrl}forgot-password";
  static String verifyOtpApi = "${baseUrl}verify-otp";
  static String resendOtpApi = "${baseUrl}resend-otp";
  static String resetPasswordApi = "${baseUrl}reset-password";
  static String countryApi = "${baseUrl}country";
  static String profileApi = "${baseUrl}profile";
  static String moviesListApi = "${baseUrl}movies";
  static String masterListingApi = "${baseUrl}master-listing";
  static String guestLoginApi = "${baseUrl}guest-login";
  static String logoutApi = "${baseUrl}logout";

  static Future<LoginUserModel?> getLoginMethod(
      String email, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
    final platformName = getPlatformName();
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {
      "email": email,
      "password": password,
      "device_token": fcmToken,
      "device_type": platformName
    };
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(loginApi),
        headers: {"Content-Type": "application/json"}, body: body);
    if (kDebugMode) {
      print('login body >>>>>>$body');
      print('login response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<ForgetPasswordModel?> getGuestLoginMethod() async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    http.Response response = await http.post(Uri.parse(guestLoginApi),
        headers: {"Content-Type": "application/json"});
    if (kDebugMode) {
      print('guest login response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<SignUpUserModel?> getSignupMethod(
      String userName, String email, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final platformName = getPlatformName();
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {
      "username": userName,
      "email": email,
      "password": password,
      "device_token": fcmToken,
      "device_type": platformName
    };
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(signupApi),
        headers: {"Content-Type": "application/json"}, body: body);
    if (kDebugMode) {
      print('sign up body >>>>>>$body');
      print('sign up response >>>>>${response.body}');
    }
    var data = jsonDecode(response.body);
    SignUpUserModel user = SignUpUserModel.fromJson(data);

    if (data is Map && data.containsKey("error")) {
      Fluttertoast.showToast(msg: data["error"]);
      return null; // stop here
    }
    if (response.statusCode == 200) {
      return user;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<ForgetPasswordModel?> getForgetPasswordMethod(
      String email) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {"email": email};
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(forgotPasswordApi),
        headers: {"Content-Type": "application/json"}, body: body);
    if (kDebugMode) {
      print('forget password body >>>>>>$body');
      print('forget password response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      ForgetPasswordModel user = ForgetPasswordModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<FilterListModel?> getFilterListMethod() async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    http.Response response = await http.get(Uri.parse(masterListingApi),
        headers: {"Content-Type": "application/json"});
    if (kDebugMode) {
      print('master list api response >>>>>${response.body}');
    }
    var data = jsonDecode(response.body);
    FilterListModel user = FilterListModel.fromJson(data);
    if (response.statusCode == 200) {
      return user;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<LoginUserModel?> getVerifyOtpMethod(
      String email, String otp, String token) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {
      "email": email,
      "otp": otp,
    };
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(verifyOtpApi),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $token",
        },
        body: body);
    if (kDebugMode) {
      print('otp verify body >>>>>>$body');
      print('otp verify response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      LoginUserModel user = LoginUserModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<CommonModel?> getResendOtpMethod(String email) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {"email": email};
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(resendOtpApi),
        headers: {"Content-Type": "application/json"}, body: body);
    if (kDebugMode) {
      print('otp verify body >>>>>>$body');
      print('otp verify response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<CommonModel?> getResetPasswordMethod(
      String newPassword, String token) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {"new_password": newPassword};
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(resetPasswordApi),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $token"
        },
        body: body);
    if (kDebugMode) {
      print('reset password body >>>>>>$body');
      print('reset password response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<DashboardGetMovieModel?> getMoviesListMethod(
      String popularity,
      String mostPopularity,
      String director,
      String origin,
      String bottScore,
      String buildRecently,
      String genre,
      String language,
      String quality,
      String actor,
      String search,
      String application,
      String appType,
      String token) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    Map params = {
      "Popularity": popularity,
      "mostPopularity": mostPopularity,
      "director": director,
      "origin": origin,
      "BOTT_score": bottScore,
      "build_recently": buildRecently,
      "genre": genre,
      "language": language,
      "quality": quality,
      "actor": actor,
      "search": search,
      "application": application,
      "app_type": appType
    };
    var body = jsonEncode(params);
    http.Response response = await http.post(Uri.parse(moviesListApi),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $token",
        },
        body: body);
    if (kDebugMode) {
      print('dashboard data body >>>>>>$body');
      print('dashboard data response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      DashboardGetMovieModel user = DashboardGetMovieModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      DashboardGetMovieModel user = DashboardGetMovieModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      DashboardGetMovieModel user = DashboardGetMovieModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      DashboardGetMovieModel user = DashboardGetMovieModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<CountryModel?> getCountryMethod() async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    http.Response response = await http.get(Uri.parse(countryApi),
        headers: {"Content-Type": "application/json"});
    if (kDebugMode) {
      print('country response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CountryModel user = CountryModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      CountryModel user = CountryModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      CountryModel user = CountryModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CountryModel user = CountryModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<ProfileModel?> getProfileApiMethod(
      String token, BuildContext context) async {
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    try {
      http.Response response = await http.get(Uri.parse(profileApi), headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token"
      });
      if (kDebugMode) {
        print('get profile response >>>>>${response.body}');
      }
      var data = jsonDecode(response.body);
      ProfileModel user = ProfileModel.fromJson(data);
      if (response.statusCode == 200) {
        return user;
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: user.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR);
        return user;
      } else if (response.statusCode == 401 &&
          (ProfileModel.fromJson(data)
                  .message
                  ?.toLowerCase()
                  .contains("token has expired") ??
              false)) {
        await HelperSaveData.helperSaveData.logout(context);

        Fluttertoast.showToast(
          msg: "Session expired. Please login again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
        );
        return null;
      } else {
        Fluttertoast.showToast(
            msg: user.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR);
        return user;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "error $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return null;
    }
  }

  static Future<CommonModel?> getLogoutMethod(String token) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    http.Response response = await http.post(Uri.parse(logoutApi), headers: {
      "Content-Type": "application/json",
      'Authorization': "Bearer $token"
    });
    if (kDebugMode) {
      print('logout response >>>>>${response.body}');
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CommonModel user = CommonModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }

  static Future<ProfileModel?> getUpdateProfileMethod(
      String fullName,
      String age,
      String gender,
      String countryIn,
      String countryBorn,
      File file,
      String token) async {
    // Check internet before proceeding
    bool isConnected = await checkNetwork();
    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      return null;
    }
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(profileApi));
    request.fields["full_name"] = fullName;
    request.fields["age"] = age;
    request.fields["gender"] = gender;
    request.fields["country_in"] = countryIn;
    request.fields["country_born"] = countryBorn;
    //add text fields
    var pic1 = await http.MultipartFile.fromPath("image", file.path);
    request.files.add(pic1);
    request.headers["Authorization"] = "Bearer $token";

    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (kDebugMode) {
      print("profile Image Upload --->  $responseString");
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(responseString);
      ProfileModel user = ProfileModel.fromJson(data);
      return user;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(responseString);
      ProfileModel user = ProfileModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else if (response.statusCode == 401) {
      var data = jsonDecode(responseString);
      ProfileModel user = ProfileModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    } else {
      var data = jsonDecode(responseString);
      ProfileModel user = ProfileModel.fromJson(data);
      Fluttertoast.showToast(
          msg: user.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      return user;
    }
  }
}
