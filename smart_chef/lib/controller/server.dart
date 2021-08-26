import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:smart_chef/controller/share_preferance.dart';
import 'package:smart_chef/model/dashboard_model.dart';
import 'package:smart_chef/model/user.dart';
import 'package:smart_chef/view/screen/home_screen.dart';
import 'get_auth.dart';
import 'get_home.dart';

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

  Future<User> login({Map<String, dynamic> data}) async {
    print(authGet.domenController.value.text);
      String baseUrl = "https://"+"${authGet.domenController.value.text}"+"/api/admin/";

    initApi();
    // try {
      Response response = await dio.post(
        baseUrl + 'login',
        data: data,
      );
        print(response.data);

      if (response.data['status'] == 'error') {
        authGet.isLoginLoading.value = false;
        authGet.loginErrorString.value = response.data['massage'];
        throw DioError(error: response.data['massage'], response: response);
      } else {
        authGet.loginErrorString.value = null;
        authGet.isLoginLoading.value = false;
        authGet.loginSuccess.value = true;
        Future.delayed(
          Duration(milliseconds: 300),
          () async {
            await ShereHelper.sHelper.addNew("token", response.data['data']['token']);
            await ShereHelper.sHelper.addNew("domen", authGet.domenController.value.text);
            homeGet.token.value = response.data['data']['token'];
            homeGet.getDashboard();
            getx.Get.offAll(() => HomeScreen());
          },
        );

        return User.fromJson(response.data);
      }
    // } catch (e) {
    //   return null;
    // }
  }
//////////////////////////////////////////////////////////////////////////

  Future<DashboardModel> dashboardContent() async {
      String baseUrl = "https://"+"${authGet.domenController.value.text}"+"/api/admin/";

    initApi();
    String time = DateTime.now().toString().substring(0, 10);
    // try {
      Response response = await dio.post(baseUrl + 'orders',
          data: {'from_date': time, 'to_date': time},
          options: Options(
              headers: {'Authorization': 'Bearer ${homeGet.token.value}'}));

      if (response.data['status'] == 200) {
        return DashboardModel.fromJson(response.data['data']);
      } else {
        return homeGet.errorLoadingDashboard.value = response.data['massage'];
      }
    // } catch (e) {
    //   return null;
    // }
  }

//////////////////////////////////////////////////////////////////////////

  Future<DashboardModel> updateOrder({Map<String, dynamic> data}) async {
      String baseUrl = "https://"+"${authGet.domenController.value.text}"+"/api/admin/";

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
