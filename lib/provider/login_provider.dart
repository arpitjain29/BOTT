import 'package:flutter/material.dart';
import '../model/forget_password_model.dart';
import '../model/login_user_model.dart';
import '../utils/helper_save_data.dart';
import '../utils/util_api.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoadingGuest = false;
  LoginUserModel? _loginUserModel;

  bool get isLoading => _isLoading;
  bool get isLoadingGuest => _isLoadingGuest;
  LoginUserModel? get loginUserModel => _loginUserModel;

  ForgetPasswordModel? _guestUserModel;
  ForgetPasswordModel? get guestUserModel => _guestUserModel;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _loginUserModel = await UtilApi.getLoginMethod(email, password);
    if(_loginUserModel?.status == 200){
      await HelperSaveData.helperSaveData.setBoolValue("isGuest", false);
    }
    _isLoading = false;
    notifyListeners();

    return _loginUserModel?.status == 200;
  }

  Future<bool> guestLogin() async {
    _isLoadingGuest = true;
    notifyListeners();


    try {
      _guestUserModel = await UtilApi.getGuestLoginMethod();
      if(_guestUserModel?.status == 200){
        await HelperSaveData.helperSaveData.setBoolValue("isGuest", true);
      }
    } catch (e) {
      _guestUserModel = ForgetPasswordModel(
        status: 500,
        message: 'Something went wrong',
      );
    }

    _isLoadingGuest = false;
    notifyListeners();

    return _guestUserModel?.status == 200;
  }

  String? get message => _loginUserModel?.message ?? _guestUserModel?.message;
}