import 'package:bott/model/DashboardGetMovieModel.dart' hide Application, Type;
import 'package:bott/model/FilterListModel.dart';
import 'package:bott/screens/ProfileScreen.dart';
import 'package:bott/utils/ImagePaths.dart';
import 'package:bott/utils/TextView.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/LoginUserModel.dart';
import '../provider/HomeProvider.dart';
import '../utils/AppColors.dart';
import '../utils/Fonts.dart';
import '../utils/HelperSaveData.dart';
import '../utils/UtilApi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  TextEditingController searchText = TextEditingController();
  var listArray = [
    "Reset",
    "Remove Most Popular",
    "Remove Popular",
    "Released After 1990",
    "Free",
    "Subscription",
    "Change Country"
  ];
  var imageArray = [
    "assets/image/ic_prime_video.webp",
    "assets/image/ic_jio_cinema.jpeg",
    "assets/image/ic_sony_image.png",
    "assets/image/ic_netflix.webp",
    "assets/image/ic_disney_hotstar.webp",
    "assets/image/ic_netflix.webp",
    "assets/image/ic_disney_hotstar.webp",
  ];
  var categoryArray = [
    "Actor",
    "Quality",
    "Price",
    "BOTT Score",
    "Popularity",
    "Genre",
    "Country Of Origins",
    "Language",
    "Type",
  ];
  var popularityArray = [
    "Most Popular",
    "Popular",
    "Visited by Decent Amount",
    "Mechanical",
    "Visited by fewer"
  ];

  String? selectCategoryTitle;
  List<dynamic> filterListArray = [];

  List<dynamic> selectedList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchMovies(context);
      Provider.of<HomeProvider>(context, listen: false).fetchProfile(context);
    });
    searchText.addListener(_onSearchChanged);
    filterListApi();
  }

  SharedPreferences? pref;
  bool clickLoad = false;
  FilterListModel? filterListModel;

  void filterListApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      clickLoad = true;
    });
    filterListModel = await UtilApi.getFilterListMethod();

    if (filterListModel!.status == "200") {
      print(
          "filter data application name ========== ${filterListModel!.data!.applications![0].name}");
    } else {
      Fluttertoast.showToast(
          msg: filterListModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  @override
  void dispose() {
    searchText.removeListener(_onSearchChanged);
    searchText.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<HomeProvider>(context, listen: false)
        .searchMovies(searchText.text);
  }

  void _showAlertDialog(BuildContext context, DatumMovieList? listData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: AppColors.colorTransparent,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.color1F2437 : AppColors.colorWhite,
              border: Border.all(
                  color: isDark ? AppColors.color313A5A : Colors.black,
                  width: 1.0,
                  style: BorderStyle.solid),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FadeInImage.assetNetwork(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            placeholder: ImagePaths.noImage,
                            image: listData?.images?.image ?? "",
                            imageErrorBuilder: (context, error, stack) {
                              return Image.asset(
                                fit: BoxFit.fill,
                                ImagePaths.noImage,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  listData?.origin ?? "",
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.color96A4C3
                                          : AppColors.colorGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: Fonts.metropolisRegular),
                                ),
                                Text(
                                  listData?.name ?? "",
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.colorWhite
                                          : AppColors.colorGrey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      fontFamily: Fonts.metropolisSemiBold),
                                ),
                                Text(
                                  listData?.genreName ?? "",
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.color96A4C3
                                          : AppColors.colorGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: Fonts.metropolisRegular),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Image.asset(
                                    "assets/image/ic_netflix.webp",
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  "Director · ${listData?.director}",
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.color96A4C3
                                          : AppColors.colorGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: Fonts.metropolisRegular),
                                ),
                                Text(
                                  "Actor · ${listData?.actorName}",
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.color96A4C3
                                          : AppColors.colorGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: Fonts.metropolisRegular),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 10, left: 27),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: AppColors.colorE8A818,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            "${listData?.bottScore}%",
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.colorWhite
                                    : AppColors.colorBlack,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: Fonts.metropolisRegular),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        listData?.desc ?? "",
                        style: TextStyle(
                            color: isDark
                                ? AppColors.color96A4C3
                                : AppColors.colorGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: Fonts.metropolisRegular),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Divider(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.color646D91
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.color646D91
                                  : Colors.grey.shade200,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "Watchlist",
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.colorWhite
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: Fonts.metropolisRegular),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.color646D91
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.color646D91
                                  : Colors.grey.shade200,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "Not Interested",
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.colorWhite
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: Fonts.metropolisRegular),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.color646D91
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.color646D91
                                  : Colors.grey.shade200,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "Seen",
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.colorWhite
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: Fonts.metropolisRegular),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Divider(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    listData!.firstSecondApp!.isEmpty
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Streaming",
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.colorWhite
                                      : AppColors.colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: Fonts.metropolisRegular),
                            ),
                          ),
                    listData.firstSecondApp!.isEmpty
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listData.firstSecondApp?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.color646D91
                                      : Colors.grey.shade200,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.color646D91
                                        : Colors.grey.shade200,
                                    width: 2,
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  children: [
                                    Image.network(
                                      listData.firstSecondApp?[index]
                                              .application?.icon ??
                                          "",
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              listData.firstSecondApp?[index]
                                                      .application?.name ??
                                                  "",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? AppColors.colorWhite
                                                      : AppColors.colorBlack,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Fonts.metropolisRegular),
                                            ),
                                            Text(
                                              listData.firstSecondApp?[index]
                                                      .appType ??
                                                  "",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? AppColors.color96A4C3
                                                      : AppColors.colorGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Fonts.metropolisRegular),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/image/ic_link.png",
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            }),
                    listData.appTypeUrls!.isEmpty
                        ? Container()
                        : Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "Rent",
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.colorWhite
                                      : AppColors.colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: Fonts.metropolisRegular),
                            ),
                          ),
                    listData.appTypeUrls!.isEmpty
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listData.appTypeUrls?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.color646D91
                                      : Colors.grey.shade200,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.color646D91
                                        : Colors.grey.shade200,
                                    width: 2,
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  children: [
                                    Image.network(
                                      listData.appTypeUrls?[index].application
                                              ?.icon ??
                                          "",
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              listData.appTypeUrls?[index]
                                                      .application?.name ??
                                                  "",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? AppColors.colorWhite
                                                      : AppColors.colorBlack,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Fonts.metropolisRegular),
                                            ),
                                            Text(
                                              listData.appTypeUrls?[index]
                                                      .price ??
                                                  "",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? AppColors.color96A4C3
                                                      : AppColors.colorGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Fonts.metropolisRegular),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/image/ic_link.png",
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double bottScore = 0;
  double priceView = 0;

  void _showAlertFilterDialog(BuildContext context, HomeProvider homeProvider) {
    filterListFunction(0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int selectedCategoryIndex = 0;
    List<dynamic> selectedFilters = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
                shadowColor: AppColors.colorTransparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.color1F2437 : AppColors.colorWhite,
                    border: Border.all(
                      color: isDark ? AppColors.color313A5A : Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "More Filter",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.color96A4C3
                                          : AppColors.colorBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      fontFamily: Fonts.metropolisRegular),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final data = filterListModel!.data;
                                final Map<String, List<int>> filterMap = {
                                  "app_type": [],
                                  "application": [],
                                  "actor": [],
                                  "origin": [],
                                  "genre": [],
                                  "language": [],
                                  "quality": [],
                                };

                                for (var item in selectedFilters) {
                                  if (item is Type) {
                                    if (data?.appType
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["app_type"]?.add(item.id!);
                                    } else if (data?.actorType
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["actor"]?.add(item.id!);
                                    }
                                  } else if (item is Application) {
                                    if (data?.applications
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["application"]?.add(item.id!);
                                    } else if (data?.origins
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["origin"]?.add(item.id!);
                                    } else if (data?.genre
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["genre"]?.add(item.id!);
                                    } else if (data?.languages
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["language"]?.add(item.id!);
                                    } else if (data?.quality
                                            ?.any((e) => e.id == item.id) ==
                                        true) {
                                      filterMap["quality"]?.add(item.id!);
                                    }
                                  }
                                }

                                // 🔧 Create final API map with all keys
                                final Map<String, String> apiParams = {
                                  "Popularity": "",
                                  "mostPopularity": "",
                                  "director": "",
                                  "origin": filterMap["origin"]!.join(','),
                                  "BOTT_score": bottScore.toInt().toString(),
                                  "build_recently": "",
                                  "genre": filterMap["genre"]!.join(','),
                                  "language": filterMap["language"]!.join(','),
                                  "quality": filterMap["quality"]!.join(','),
                                  "actor": filterMap["actor"]!.join(','),
                                  "search": "",
                                  "application":
                                      filterMap["application"]!.join(','),
                                  "app_type": filterMap["app_type"]!.join(','),
                                };

                                print("🔗 Sending filter to API:\n$apiParams");

                                homeProvider.submitFilter(apiParams, context);

                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                child: TextView(label: "Apply"),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedFilters.clear();
                                  homeProvider.resetFilters(context);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                child: TextView(label: "Reset"),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedFilters.clear();
                                });
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: isDark
                                    ? AppColors.color96A4C3
                                    : AppColors.colorGrey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        // Body Scrollable Area
                        Expanded(
                          child: Row(
                            children: [
                              // Left Category List
                              Expanded(
                                flex: 2,
                                child: ListView.builder(
                                  itemCount: categoryArray.length,
                                  itemBuilder: (context, index) {
                                    final isSelected =
                                        index == selectedCategoryIndex;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategoryIndex = index;
                                          filterListFunction(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? (isDark
                                                  ? AppColors.color1F2437
                                                  : AppColors.colorE8A818)
                                              : (isDark
                                                  ? AppColors.color646D91
                                                  : Colors.grey.shade200),
                                          border: Border.all(
                                            color: isDark
                                                ? AppColors.color646D91
                                                : Colors.grey.shade200,
                                            width: 2,
                                          ),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Text(
                                          categoryArray[index],
                                          style: TextStyle(
                                              color: isDark
                                                  ? AppColors.colorWhite
                                                  : AppColors.colorBlack,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              fontFamily:
                                                  Fonts.metropolisRegular),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Right Filter Items
                              Expanded(
                                flex: 3,
                                child: selectCategoryTitle ==
                                        categoryArray[
                                            2]
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Price",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Fonts.metropolisRegular,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Price: ${priceView.toInt()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  Fonts.metropolisRegular,
                                            ),
                                          ),
                                          Slider(
                                            value: priceView,
                                            min: 0,
                                            max: 100,
                                            onChanged: (value) {
                                              setState(() {
                                                priceView = value;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : selectCategoryTitle ==
                                            categoryArray[
                                                3]
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "BOTT Score",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      Fonts.metropolisRegular,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "BOTT Score: ${bottScore.toInt()}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Fonts.metropolisRegular,
                                                ),
                                              ),
                                              Slider(
                                                value: bottScore,
                                                min: 0,
                                                max: 100,
                                                onChanged: (value) {
                                                  setState(() {
                                                    bottScore = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectCategoryTitle ?? '',
                                                style: TextStyle(
                                                    color: isDark
                                                        ? AppColors.colorWhite
                                                        : AppColors.colorBlack,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    fontFamily: Fonts
                                                        .metropolisRegular),
                                              ),
                                              const SizedBox(height: 10),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      filterListArray.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Application?
                                                        applicationFilterItem;
                                                    Type? typeFilterItem;
                                                    String? popularityString;
                                                    if (filterListArray[index]
                                                        is Application) {
                                                      applicationFilterItem =
                                                          filterListArray[index]
                                                              as Application;
                                                    } else if (filterListArray[
                                                        index] is Type) {
                                                      typeFilterItem =
                                                          filterListArray[index]
                                                              as Type;
                                                    } else {
                                                      popularityString =
                                                          filterListArray[index]
                                                              as String?;
                                                    }

                                                    final item =
                                                        filterListArray[index];
                                                    final isSelected =
                                                        selectedFilters
                                                            .contains(item);

                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: isDark
                                                              ? AppColors
                                                                  .color646D91
                                                              : Colors.grey
                                                                  .shade200,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            value: isSelected,
                                                            onChanged: (bool?
                                                                newValue) {
                                                              setState(() {
                                                                if (newValue ==
                                                                    true) {
                                                                  selectedFilters
                                                                      .add(
                                                                          item);
                                                                } else {
                                                                  selectedFilters
                                                                      .remove(
                                                                          item);
                                                                }
                                                              });
                                                            },
                                                            checkColor: Theme.of(
                                                                            context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.white,
                                                            activeColor: Theme.of(
                                                                            context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? AppColors
                                                                    .colorFF8049
                                                                : AppColors
                                                                    .colorFF8049,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              applicationFilterItem !=
                                                                      null
                                                                  ? applicationFilterItem
                                                                          .name ??
                                                                      ''
                                                                  : typeFilterItem
                                                                          ?.name ??
                                                                      popularityString ??
                                                                      '',
                                                              style: TextStyle(
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .colorWhite
                                                                      : AppColors
                                                                          .colorBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14,
                                                                  fontFamily: Fonts
                                                                      .metropolisRegular),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: AppColors.colorTransparent,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.color1F2437 : AppColors.colorWhite,
              border: Border.all(
                  color: isDark ? AppColors.color313A5A : Colors.black,
                  width: 1.0,
                  style: BorderStyle.solid),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                        fontFamily: Fonts.interMedium,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          child: TextView(label: "Cancel"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<HomeProvider>(context, listen: false)
                              .logout(context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          child: TextView(label: "Logout"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.color0F172D : AppColors.colorWhite,
      drawer: myDrawer(context),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                        height: 50, width: 50, ImagePaths.appLogoNew),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.color161B2E
                              : AppColors.colorE8B931,
                          isDark
                              ? AppColors.color161B2E
                              : AppColors.colorE8B931,
                          isDark
                              ? AppColors.color161B2E
                              : AppColors.colorE8B931,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: searchText,
                      decoration: InputDecoration(
                          fillColor: AppColors.colorTransparent,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          counterText: '',
                          hintStyle: TextStyle(
                              color: AppColors.color4D4D4D,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              fontFamily: Fonts.interMedium),
                          hintText: 'Search Movies',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.color313A5A
                                    : AppColors.colorTransparent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.color313A5A
                                    : AppColors.colorTransparent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          prefixIcon: Icon(Icons.search)),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Image.asset("assets/image/ic_like.png"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.colorE8A818),
                      child: Consumer<HomeProvider>(
                        builder: (context, homeProvider, child) {
                          final profileImage =
                              homeProvider.profileData?.data?.profileImageUrl;

                          return profileImage != null && profileImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    profileImage,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _defaultProfileIcon();
                                    },
                                  ),
                                )
                              : _defaultProfileIcon();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageArray.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: ClipOval(
                      child: Image.asset(
                        imageArray[index],
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  _showAlertFilterDialog(context, homeProvider);
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.color161B2E : AppColors.colorE5E5E5,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                      color: isDark
                          ? AppColors.color313A5A
                          : AppColors.colorE8A818,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        ImagePaths.filter,
                        height: 20,
                        width: 20,
                        color:
                            isDark ? AppColors.colorWhite : AppColors.colorGrey,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          "More Filters",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDark
                                  ? AppColors.colorWhite
                                  : Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: Fonts.metropolisRegular),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listArray.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.color161B2E
                                  : AppColors.colorE5E5E5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.color313A5A
                                    : AppColors.colorE8A818,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                listArray[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: isDark
                                        ? AppColors.color646D91
                                        : Colors.grey.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: Fonts.metropolisRegular),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
          Expanded(
            child:
                Consumer<HomeProvider>(builder: (context, homeProv, snapshot) {
              if (homeProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (homeProvider.currentMovieData.isEmpty) {
                return Center(child: TextView(label: "No data available"));
              } else {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: homeProvider.currentMovieData.length,
                    itemBuilder: (context, index) {
                      var movie = homeProvider.currentMovieData[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.color1F2437
                              : AppColors.colorWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  isDark ? AppColors.color313A5A : Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid),
                        ),
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            // _showAlertDialog(context);
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      height: 150,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      placeholder: ImagePaths.noImage,
                                      image: movie.images?.image ?? "",
                                      imageErrorBuilder:
                                          (context, error, stack) {
                                        return Image.asset(
                                          height: 150,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          ImagePaths.noImage,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.origin ?? "",
                                            style: TextStyle(
                                                color: isDark
                                                    ? AppColors.color96A4C3
                                                    : AppColors.colorGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                fontFamily:
                                                    Fonts.metropolisRegular),
                                          ),
                                          Text(
                                            movie.name ?? "",
                                            style: TextStyle(
                                                color: isDark
                                                    ? AppColors.colorWhite
                                                    : AppColors.colorGrey,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                fontFamily:
                                                    Fonts.metropolisSemiBold),
                                          ),
                                          Text(
                                            movie.genreName ?? "",
                                            style: TextStyle(
                                                color: isDark
                                                    ? AppColors.color96A4C3
                                                    : AppColors.colorGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                fontFamily:
                                                    Fonts.metropolisRegular),
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/image/ic_agoda_app.png",
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 15),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: isDark
                                                        ? AppColors.color161B2E
                                                        : Colors.white,
                                                    side: BorderSide(
                                                        color: isDark
                                                            ? AppColors
                                                                .color313A5A
                                                            : AppColors
                                                                .colorGrey,
                                                        width: 2),
                                                    textStyle: TextStyle(
                                                      color: isDark
                                                          ? AppColors.colorWhite
                                                          : AppColors
                                                              .colorE8A818,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _showAlertDialog(
                                                        context, movie);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Text(
                                                      "more options",
                                                      style: TextStyle(
                                                          color: isDark
                                                              ? AppColors
                                                                  .color646D91
                                                              : AppColors
                                                                  .colorE8A818,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: Fonts
                                                              .metropolisRegular,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 10,
                                        left: 27),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      border: Border.all(
                                        color: AppColors.colorE8A818,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "${movie.bottScore}%",
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.colorWhite
                                              : AppColors.colorBlack,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: Fonts.metropolisRegular),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  movie.desc ?? "",
                                  style: TextStyle(
                                      color: isDark
                                          ? AppColors.color96A4C3
                                          : AppColors.colorGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: Fonts.metropolisRegular),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _defaultProfileIcon() {
    return Image.asset(
      "assets/image/ic_profile.png",
      height: 50,
      width: 50,
      fit: BoxFit.cover,
    );
  }

  Widget myDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<LoginUserModel?>(
          future: HelperSaveData.helperSaveData.loadLoginUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final isGuest = snapshot.data?.data?.user == null;
            final userName =
                isGuest ? 'Guest' : (snapshot.data?.data?.user?.username ?? '');
            final userEmail = isGuest
                ? 'guest@gmail.com'
                : (snapshot.data?.data?.user?.email ?? '');
            return ListView(
              padding: const EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color.fromARGB(255, 165, 255, 137),
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : "",
                          style: TextStyle(fontSize: 30.0, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userName,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: Fonts.metropolisRegular),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: Fonts.metropolisRegular),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('My Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            );
          }),
    );
  }

  void filterListFunction(int index) {
    selectCategoryTitle = categoryArray[index];
    selectCategoryTitle == categoryArray[0]
        ? filterListArray = filterListModel?.data?.actorType ?? []
        : selectCategoryTitle == categoryArray[1]
            ? filterListArray = filterListModel?.data?.quality ?? []
            : selectCategoryTitle == categoryArray[4]
                ? filterListArray = popularityArray
                : selectCategoryTitle == categoryArray[5]
                    ? filterListArray = filterListModel?.data?.genre ?? []
                    : selectCategoryTitle == categoryArray[6]
                        ? filterListArray = filterListModel?.data?.origins ?? []
                        : selectCategoryTitle == categoryArray[7]
                            ? filterListArray =
                                filterListModel?.data?.languages ?? []
                            : selectCategoryTitle == categoryArray[8]
                                ? filterListArray =
                                    filterListModel?.data?.appType ?? []
                                : [];
  }
}
