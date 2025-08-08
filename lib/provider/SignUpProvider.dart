import 'package:flutter/material.dart';
import '../model/ForgetPasswordModel.dart';
import '../model/SignUpUserModel.dart';
import '../utils/HelperSaveData.dart';
import '../utils/UtilApi.dart';

class SignUpProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoadingGuest = false;
  SignUpUserModel? _signUpUserModel;

  bool get isLoading => _isLoading;
  bool get isLoadingGuest => _isLoadingGuest;
  SignUpUserModel? get signUpUserModel => _signUpUserModel;

  ForgetPasswordModel? _guestUserModel;
  ForgetPasswordModel? get guestUserModel => _guestUserModel;

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _signUpUserModel = await UtilApi.getSignupMethod(name, email, password);
    if(_signUpUserModel?.status == 200){
      await HelperSaveData.helperSaveData.setBoolValue("isGuest", false);
    }
    _isLoading = false;
    notifyListeners();

    return _signUpUserModel?.status == 200;
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

  String? get message => _signUpUserModel?.message ?? _guestUserModel?.message;

  // String? get message => _signUpUserModel?.message;
}
