import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:get/get.dart';
import 'package:smart_chef/controller/share_preferance.dart';
import 'package:smart_chef/view/screen/login_screen.dart';

class AuthGet extends GetxController {
  RxBool isLoginLoading = false.obs;
  Rx<TextEditingController> domenController = TextEditingController().obs;

  RxBool loginSuccess = false.obs;

  RxString loginErrorString = "".obs;
  void signOut() {
    ShereHelper.sHelper.removeUser();
    // OneSignal.shared.setSubscription(false);
    Get.offAll(() => LoginScreen());
    // sl<NavigationService>().navigateToAndRemove(route.login);
  }
}
