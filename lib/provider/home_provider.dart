import 'package:bott/utils/user_data_save.dart';
import 'package:bott/utils/util_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/dashboard_get_movie_model.dart';
import '../model/login_user_model.dart';
import '../model/profile_model.dart';
import '../utils/helper_save_data.dart';

class HomeProvider extends ChangeNotifier {
  DashboardGetMovieModel? _moviesList;
  DashboardGetMovieModel? _filteredMoviesList;
  bool _isLoading = false;
  SharedPreferences? pref;

  DashboardGetMovieModel? get moviesList => _moviesList;

  DashboardGetMovieModel? get filteredMoviesList => _filteredMoviesList;

  bool get isLoading => _isLoading;

  ProfileModel? _profileData;

  ProfileModel? get profileData => _profileData;

  List<DatumMovieList> get currentMovieData {
    return _filteredMoviesList?.data?.data ?? [];
  }

  String selectedCategory = "";
  Map<String, String> _activeFilters = {}; // <-- New filter map

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  // void submitFilter(Map<String, String> filters) {
  //   // Send to API using http/dio
  //   print("Sending selected IDs to API: $filters");
  //
  //   // Example API call:
  //   // ApiService.sendFilterData({"ids": selectedIds});
  // }

  void submitFilter(Map<String, String> filters, BuildContext context) {
    _activeFilters = filters;
    print("Sending selected IDs to API: $_activeFilters");
    fetchMovies(context);
  }

  void resetFilters(BuildContext context) {
    // selectedFilters.clear();
    _activeFilters.clear();
    fetchMovies(context);
  }

  Future<void> fetchMovies(BuildContext context) async {
    _setLoading(true);

    try {
      String? popularity = _activeFilters["popularity"] ?? "";
      String? mostPopularity = _activeFilters["most_popularity"] ?? "";
      String? director = _activeFilters["director"] ?? "";
      String? origin = _activeFilters["origin"] ?? "";
      String? bottScore = _activeFilters["bott_score"] ?? "";
      String? buildRecently = _activeFilters["build_recently"] ?? "";
      String? genre = _activeFilters["genre"] ?? "";
      String? language = _activeFilters["language"] ?? "";
      String? quality = _activeFilters["quality"] ?? "";
      String? actor = _activeFilters["actor"] ?? "";
      String? search = _activeFilters["search"] ?? "";
      String? application = _activeFilters["application"] ?? "";
      String? appType = _activeFilters["app_type"] ?? "";

      pref = await SharedPreferences.getInstance();
      LoginUserModel? user =
          await HelperSaveData.helperSaveData.loadLoginUsers();
      String? token;

      bool isGuest =
          await HelperSaveData.helperSaveData.getBoolValue("isGuest") ?? false;
      if (isGuest) {
        print("login user isGuest ======== $isGuest");
        token = pref?.getString(UserDataSave.token);
      } else {
        token = user?.data?.accessToken?.token ?? '';
      }

      print("token ======== $token");

      if (token!.isNotEmpty) {
        final result = await UtilApi.getMoviesListMethod(
            popularity,
            mostPopularity,
            director,
            origin,
            bottScore,
            buildRecently,
            genre,
            language,
            quality,
            actor,
            search,
            application,
            appType,
            token);

        if (result?.status == "200") {
          _moviesList = result;
          _filteredMoviesList = result;
        } else {
          if ((result?.message ?? "")
              .toLowerCase()
              .contains("token has expired")) {
            await HelperSaveData.helperSaveData.logout(context);

            Fluttertoast.showToast(
              msg: "Session expired. Please login again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: "Token missing. Please login again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to fetch movies: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    _setLoading(false);
  }

  void searchMovies(String query) {
    if (_moviesList == null ||
        _moviesList!.data == null ||
        _moviesList!.data!.data == null) {
      _filteredMoviesList = null;
      notifyListeners();
      return;
    }

    if (query.isEmpty) {
      _filteredMoviesList = _moviesList;
    } else {
      final List<DatumMovieList> filteredDatumMoviesList =
          _moviesList!.data!.data!.where((movie) {
        final String movieName = movie.name ?? '';
        return movieName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      final Data filteredData = Data(
        currentPage: _moviesList!.data!.currentPage,
        data: filteredDatumMoviesList,
        firstPageUrl: _moviesList!.data!.firstPageUrl,
        from: _moviesList!.data!.from,
        lastPage: _moviesList!.data!.lastPage,
        lastPageUrl: _moviesList!.data!.lastPageUrl,
        links: _moviesList!.data!.links,
        nextPageUrl: _moviesList!.data!.nextPageUrl,
        path: _moviesList!.data!.path,
        perPage: _moviesList!.data!.perPage,
        prevPageUrl: _moviesList!.data!.prevPageUrl,
        to: _moviesList!.data!.to,
        total: filteredDatumMoviesList.length,
      );

      _filteredMoviesList = DashboardGetMovieModel(
        status: _moviesList!.status,
        message: _moviesList!.message,
        data: filteredData,
      );
    }
    notifyListeners();
  }

  Future<void> fetchProfile(BuildContext context) async {
    _setLoading(true);

    try {
      pref = await SharedPreferences.getInstance();
      LoginUserModel? user =
          await HelperSaveData.helperSaveData.loadLoginUsers();
      String? token;

      bool isGuest =
          await HelperSaveData.helperSaveData.getBoolValue("isGuest") ?? false;
      if (isGuest) {
        token = pref?.getString(UserDataSave.token);
      } else {
        token = user?.data?.accessToken?.token ?? '';
      }

      if (token!.isNotEmpty) {
        final result = await UtilApi.getProfileApiMethod(token, context);

        if (result != null) {
          _profileData = result;
        } else {
          Fluttertoast.showToast(
            msg: "Failed to load profile.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Token missing. Please login again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Profile fetch error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);

    try {
      LoginUserModel? user =
          await HelperSaveData.helperSaveData.loadLoginUsers();
      String? token;

      bool isGuest =
          await HelperSaveData.helperSaveData.getBoolValue("isGuest") ?? false;
      if (isGuest) {
        token = pref?.getString(UserDataSave.token);
      } else {
        token = user?.data?.accessToken?.token ?? '';
      }

      if (token!.isNotEmpty) {
        final result = await UtilApi.getLogoutMethod(token);
        if (result?.status == 200) {
          Fluttertoast.showToast(
            msg: result?.message ?? "Logged out",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );

          // Clear saved login data
          await HelperSaveData.helperSaveData.logout(context);
        } else {
          Fluttertoast.showToast(
            msg: result?.message ?? "Logout failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Token missing",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Logout error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
