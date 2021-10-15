import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:smart_chef/controller/share_preferance.dart';
import 'package:smart_chef/model/dashboard_model.dart';
import 'package:smart_chef/model/user.dart';
import 'package:smart_chef/view/screen/home_screen.dart';
import 'package:smart_chef/view/screen/login_screen.dart';
import 'get_auth.dart';
import 'get_home.dart';
import 'notification_firebase.dart';

class Server {
  Server._();
  static Server serverProvider = Server._();
  Dio dio;
  initApi() {
    if (dio == null) {
      dio = Dio();
      return dio;
    } else {
      return dio;
    }
  }

  AuthGet authGet = getx.Get.find();
  HomeGet homeGet = getx.Get.find();

//////////////////////////////////////////////////////////////////////////
  Future login({String nameController, String passwordController}) async {
    String baseUrl =
        "https://" + "${authGet.domenController.value.text}" + "/api/admin/";
    initApi();
    try {
      Response response = await dio.post(baseUrl + 'login', data: {
        'login': nameController,
        'password': passwordController,
      }, options: Options(
        validateStatus: (status) {
          return status < 500;
        },
      ));

      if (response.data['status'] == 401) {
        authGet.isLoginLoading.value = false;
        authGet.loginErrorString.value = response.data['massage'];
        throw DioError(error: response.data['massage'], response: response);
      } else {
        authGet.loginErrorString.value = null;
        authGet.isLoginLoading.value = false;
        authGet.loginSuccess.value = true;
        Future.delayed(Duration(milliseconds: 300), () async {
          if (response.statusCode == 200) {
            await ShereHelper.sHelper.setToken(response.data['data']['token']);
            await ShereHelper.sHelper
                .setDomin(authGet.domenController.value.text);
            await ShereHelper.sHelper.setName(nameController);
            await ShereHelper.sHelper.setPassword(passwordController);
            homeGet.token.value = response.data['data']['token'];
            NotificationHelper().initialNotification();
            homeGet.getDashboard();
            getx.Get.offAll(() => HomeScreen());
            return User.fromJson(response.data);
          } else {
            authGet.isLoginLoading.value = true;
            authGet.loginSuccess.value = false;
          }
        });
      }
    } catch (e) {
      authGet.isLoginLoading.value = false;
      authGet.loginErrorString.value = "Error";
      return null;
    }
  }

//////////////////////////////////////////////////////////////////////////

  Future<DashboardModel> dashboardContent() async {
    String baseUrl =
        "https://" + "${authGet.domenController.value.text}" + "/api/admin/";

    initApi();
    String time = DateTime.now().toString().substring(0, 10);
    print(time);
    try {
      Response response = await dio.post(baseUrl + 'orders',
          data: {'from_date': time, 'to_date': time},
          options: Options(
              headers: {'Authorization': 'Bearer ${homeGet.token.value}'}));
      print(response.data);
      if (response.data['status'] == 200) {
        return DashboardModel.fromJson(response.data['data']);
      } else {
        return homeGet.errorLoadingDashboard.value = response.data['massage'];
      }
    } catch (e) {
      // getx.Get.offAll(() => LoginScreen());

      return null;
    }
  }

//////////////////////////////////////////////////////////////////////////

  Future<DashboardModel> updateOrder({Map<String, dynamic> data}) async {
    String baseUrl =
        "https://" + "${authGet.domenController.value.text}" + "/api/admin/";

    Response response = await dio.post(baseUrl + 'changeStatus',
        data: data,
        options: Options(
            headers: {'Authorization': 'Bearer ${homeGet.token.value}'}));

    if (response.data['status'] == 200) {
      homeGet.getDashboard();
    } else {
      throw DioError(error: response.data['massage'], response: response);
    }
  }

//////////////////////////////////////////////////////////////////////////

}
