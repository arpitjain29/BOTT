import 'dart:io';

import 'package:bott/model/country_model.dart';
import 'package:bott/model/profile_model.dart';
import 'package:bott/screens/sign_up_screen.dart';
import 'package:bott/utils/image_paths.dart';
import 'package:bott/utils/input_text_field_with_text.dart';
import 'package:bott/utils/text_view.dart';
import 'package:bott/utils/user_data_save.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_user_model.dart';
import '../provider/home_provider.dart';
import '../utils/app_colors.dart';
import '../utils/fonts_class.dart';
import '../utils/helper_save_data.dart';
import '../utils/range_input_formatter.dart';
import '../utils/util_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  TextEditingController nameText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  TextEditingController fullNameText = TextEditingController();
  TextEditingController ageText = TextEditingController();

  @override
  void initState() {
    super.initState();
    saveData();
    countryApi();
  }

  LoginUserModel? user;
  String? tokenUser;
  SharedPreferences? pref;
  bool? isGuest;

  void saveData() async {
    pref = await SharedPreferences.getInstance();
    isGuest =
        await HelperSaveData.helperSaveData.getBoolValue("isGuest") ?? false;
    if (isGuest!) {
      print("login user isGuest ======== $isGuest");
      tokenUser = pref?.getString(UserDataSave.token);
    } else {
      user = await HelperSaveData.helperSaveData.loadLoginUsers();
      print("data login =======  ${user!.data!.accessToken!.token}");
      tokenUser = user?.data?.accessToken?.token ?? '';
    }
    getProfileApi();
  }

  bool clickLoad = false;
  CountryModel? countryModel;
  ProfileModel? profileModel;

  List<DatumCountry> dataList = [];
  String countryName = "";
  var selectCountryId;
  var selectCountryIdBorn;

  String countryNameYou = 'Country you are in';
  String countryNameBorn = 'Country you are born in';
  var genderList = ["Select gender", "Male", "Female"];
  String genderValue = "Select gender";

  String? profileImageUrl;

  int? countryInId;
  int? countryBornId;

  List<DatumCountry> get uniqueCountries {
    final seen = <String>{};
    return dataList.where((item) => seen.add(item.countryName!)).toList();
  }

  void countryApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      clickLoad = true;
    });
    countryModel = await UtilApi.getCountryMethod();

    if (countryModel!.status == "200") {
      dataList = countryModel!.data!;
    } else {
      Fluttertoast.showToast(
          msg: countryModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  void getProfileApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      clickLoad = true;
    });
    profileModel = await UtilApi.getProfileApiMethod(tokenUser!, context);

    if (profileModel!.status == 200) {
      setState(() {
        nameText.text = profileModel?.data?.username ?? "";
        fullNameText.text = profileModel?.data?.firstName ?? "";
        emailText.text = profileModel?.data?.email ?? "";
        ageText.text = profileModel?.data?.age ?? "";
        genderValue = profileModel?.data?.gender ?? "Select gender";

        countryInId = profileModel?.data?.countryIn;
        countryBornId = profileModel?.data?.countryBorn;

        countryNameYou = uniqueCountries
            .firstWhere(
              (e) => e.id == countryInId,
              orElse: () => DatumCountry(id: 0, countryName: ""),
            )
            .countryName!;

        countryNameBorn = uniqueCountries
            .firstWhere(
              (e) => e.id == countryBornId,
              orElse: () => DatumCountry(id: 0, countryName: ""),
            )
            .countryName!;
        profileImageUrl = profileModel?.data?.profileImageUrl;
      });
    } else {
      Fluttertoast.showToast(
          msg: profileModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  File? fileImage;
  ImagePicker picker = ImagePicker();

  void openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        fileImage = File(pickedFile.path);
      }
      Navigator.of(context).pop();
    });
  }

  void openGallery() async {
    var imgGallery = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imgGallery != null) {
        fileImage = File(imgGallery.path);
      }
      Navigator.of(context).pop();
    });
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text("Capture Image From Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: const Text("Take Image From Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getProfileUpdateApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      clickLoad = true;
    });
    profileModel = await UtilApi.getUpdateProfileMethod(
        nameText.text,
        ageText.text,
        genderValue,
        countryInId.toString(),
        countryBornId.toString(),
        fileImage!,
        tokenUser!);

    if (profileModel!.status == 200) {
      Fluttertoast.showToast(
          msg: profileModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      await homeProvider.fetchProfile(context);
      setState(() {
        getProfileApi();
      });
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: profileModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 200),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 35, horizontal: 35),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            InputTextFieldWithText(
                              label: "Username",
                              hintText: "Enter your username",
                              textController: nameText,
                              icon: ImagePaths.user1,
                              whiteIcon: ImagePaths.userWhite,
                              readOnly: false,
                            ),
                            InputTextFieldWithText(
                              label: "Full Name",
                              hintText: "Enter full name",
                              textController: fullNameText,
                              icon: ImagePaths.user1,
                              whiteIcon: ImagePaths.userWhite,
                              readOnly: false,
                            ),
                            InputTextFieldWithText(
                                label: "Email",
                                hintText: "Enter email",
                                textController: emailText,
                                icon: ImagePaths.email,
                                whiteIcon: "assets/image/ic_email_white.png",
                                keyboardType: TextInputType.emailAddress,
                                readOnly: true),
                            InputTextFieldWithText(
                              label: "Age",
                              hintText: "Enter age",
                              textController: ageText,
                              keyboardType: TextInputType.number,
                              icon: ImagePaths.age,
                              whiteIcon: ImagePaths.ageWhite,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                                RangeInputFormatter(min: 15, max: 99),
                              ],
                              readOnly: false,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              alignment: Alignment.topLeft,
                              child: TextView(label: "Gender"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.surface,
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset(
                                      isDark
                                          ? ImagePaths.genderWhite
                                          : ImagePaths.gender,
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: Container(),
                                      hint: Text("Select gender"),
                                      value: genderValue,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: genderList.map((String? items) {
                                        return DropdownMenuItem<String>(
                                          value: items,
                                          child: Text(
                                            items!,
                                            style: TextStyle(
                                              color: isDark
                                                  ? AppColors.colorWhite
                                                  : AppColors.colorGreyDark,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              fontFamily: Fonts.interMedium,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          genderValue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              alignment: Alignment.topLeft,
                              child: TextView(label: "Country you are in"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.surface,
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: [
                                  // Container(
                                  //   margin:
                                  //       EdgeInsets.symmetric(horizontal: 10),
                                  //   child: Image.asset(ImagePaths.countryIndia),
                                  // ),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: Container(),
                                      hint: Text("Country you are in"),
                                      value: uniqueCountries.any((e) =>
                                              e.countryName == countryNameYou)
                                          ? countryNameYou
                                          : null,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: uniqueCountries
                                          .map((DatumCountry items) {
                                        return DropdownMenuItem<String>(
                                            value: items.countryName,
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    items.countryFlag ?? '',
                                                    width: 24,
                                                    height: 24,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(Icons.flag),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  items.countryName!,
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? AppColors.colorWhite
                                                        : AppColors.color4D4D4D,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        Fonts.interMedium,
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          countryNameYou = newValue!;
                                          countryInId = uniqueCountries
                                              .firstWhere((e) =>
                                                  e.countryName == newValue)
                                              .id;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              alignment: Alignment.topLeft,
                              child: TextView(label: "Country you are born in"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.surface,
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: Container(),
                                      hint: Text("Country you are born in"),
                                      value: uniqueCountries.any((e) =>
                                              e.countryName == countryNameBorn)
                                          ? countryNameBorn
                                          : null,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: uniqueCountries
                                          .map((DatumCountry items) {
                                        return DropdownMenuItem<String>(
                                          value: items.countryName,
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: Image.network(
                                                  items.countryFlag ?? '',
                                                  width: 24,
                                                  height: 24,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context,
                                                          error,
                                                          stackTrace) =>
                                                      Icon(Icons.flag),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                items.countryName!,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? AppColors.colorWhite
                                                      : AppColors.color4D4D4D,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  fontFamily: Fonts.interMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          countryNameBorn = newValue!;
                                          countryBornId = uniqueCountries
                                              .firstWhere((e) =>
                                                  e.countryName == newValue)
                                              .id;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (isGuest!) {
                                    print(
                                        "login user isGuest ======== $isGuest");
                                    Fluttertoast.showToast(
                                        msg: "Please signup",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR);
                                    tokenUser =
                                        pref?.getString(UserDataSave.token);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignUpScreen()));
                                  } else {
                                    // Validation check
                                    if (nameText.text.trim().isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please enter your name");
                                      return;
                                    }
                                    if (ageText.text.trim().isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please enter your age");
                                      return;
                                    }
                                    if (genderValue.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please select your gender");
                                      return;
                                    }
                                    if (countryInId == null) {
                                      Fluttertoast.showToast(
                                          msg: "Please select country in");
                                      return;
                                    }
                                    if (countryBornId == null) {
                                      Fluttertoast.showToast(
                                          msg: "Please select country born");
                                      return;
                                    }
                                    if (fileImage == null) {
                                      Fluttertoast.showToast(
                                          msg: "Please select profile image");
                                      return;
                                    }
                                    user = await HelperSaveData.helperSaveData
                                        .loadLoginUsers();
                                    print("data login =======  ${user!.data!.accessToken!.token}");
                                    tokenUser =
                                        user?.data?.accessToken?.token ?? '';
                                    getProfileUpdateApi();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Text(
                                    "Visited",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Text(
                                    "Not interested",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (isGuest!) {
                                    print(
                                        "login user isGuest ======== $isGuest");
                                    tokenUser =
                                        pref?.getString(UserDataSave.token);
                                    Fluttertoast.showToast(
                                        msg: "Please signup",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignUpScreen()));
                                  } else {
                                    user = await HelperSaveData.helperSaveData
                                        .loadLoginUsers();
                                    print("data login =======  ${user!.data!.accessToken!.token}");
                                    tokenUser =
                                        user?.data?.accessToken?.token ?? '';
                                    // Navigator.push(context, MaterialPageRoute(builder: (_)=>SetPasswordScreen()));
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 120),
              child: InkWell(
                onTap: () {
                  showOptionsDialog(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                      borderRadius: BorderRadius.circular(60),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: fileImage != null
                          ? Image.file(
                              File(fileImage!.path),
                              height: 110,
                              width: 110,
                              fit: BoxFit.cover,
                            )
                          : profileImageUrl != null &&
                                  profileImageUrl!.isNotEmpty
                              ? Image.network(
                                  profileImageUrl!,
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      ImagePaths.noImage,
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/image/ic_profile.png",
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
