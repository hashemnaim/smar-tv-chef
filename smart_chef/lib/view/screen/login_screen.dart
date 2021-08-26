import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/connectvity_service.dart';
import 'package:smart_chef/controller/get_auth.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/images.dart';
import 'package:smart_chef/view/widget/custom_text_form_field.dart';
import 'package:smart_chef/view/widget/loading_indicator.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController =
      TextEditingController(text: kReleaseMode ? '' : '');
  final TextEditingController passwordController =
      TextEditingController(text: kReleaseMode ? '' : '');


  AuthGet authGet = Get.find();

  final FocusNode passwordFocus = FocusNode();
  saveForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        authGet.isLoginLoading.value = true;

      await  Server.serverProvider.login(data: {
          'login': nameController.text,
          'password': passwordController.text,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Obx(() => SafeArea(
                child: authGet.isLoginLoading.value == true
                    ? loadingWidget()
                    : loginForm(
                        context,
                        isLoading: authGet.isLoginLoading.value,
                        loginSuccess: authGet.loginSuccess.value,
                        loginError: authGet.loginErrorString.value,
                      ))),
          ),
        ],
      ),
    );
  }

  Widget loadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logo,
            height: 350,
            width: 350,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 80),
          CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget loginForm(
    BuildContext context, {
    bool isLoading = false,
    bool loginSuccess = false,
    String loginError,
  }) {
    double maxWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth / 2,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          key: Key('login_column'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Container(
              height: 90,
              margin: const EdgeInsets.only(right: 80),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  SvgPicture.asset(domain),
                                    SizedBox(width: 10),

                  Text("Https//www.",     style: TextStyle(
                        color: grey5B6163,
                        fontSize: 26,
                        fontWeight: FontWeight.w600
                      ),),
                  Expanded(
                    child: TextFormField(
                      controller:authGet. domenController.value,
                      // focusNode: currentFocusNode,
                      // textAlign: TextAlign.center,
                      // textInputAction: TextInputAction.go,
                      // obscureText: obscureText,
                      // validator: validator,
                      keyboardType: TextInputType.url,
                      style: TextStyle(
                        color: grey5B6163,
                        fontSize: 26,
                        fontWeight: FontWeight.w600
                      ),

                      onEditingComplete: () {
                        // if (nextFocusNode != null) {
                        //   FocusScope.of(sl<NavigationService>().getContext())
                        //       .requestFocus(nextFocusNode);
                        // } else {
                        //   FocusScope.of(sl<NavigationService>().getContext()).unfocus();
                        // }
                      },
                      decoration: InputDecoration(
                          // filled: true,
                          // fillColor: grey5B6163,
                          // hintText: hint,
                          // hintStyle: _style,
                          // suffixIcon: Icon(
                          //   icon,
                          //   color: greyDEDEDE,
                          //   size: 30,
                          // ),
                          // prefixIcon: suffixIcon ??
                          //     Icon(
                          //       icon,
                          //       color: Colors.transparent,
                          //     ),
                          border: InputBorder.none
                          // OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(
                          //     Radius.circular(0),
                          //   ),
                          // ),
                          ),
                    ),
                  ),

                  // TextFormField(
                  //   controller:domenController ,
                  //   // 'amberrestaurant.no',

                  //   style: TextStyle(fontSize: 30),
                  // ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    greyDEDEDE,
                    grey6F6F6F,
                  ],
                ),
              ),
            ),
            SizedBox(height: 36),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: nameController,
                            nextFocusNode: passwordFocus,
                            textInputAction: TextInputAction.next,
                            icon: Icons.person,
                            hint: 'brukernavn',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'kreves';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            controller: passwordController,
                            currentFocusNode: passwordFocus,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            icon: Icons.vpn_key,
                            hint: 'passord',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'kreves';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 90,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          saveForm();
                        },
                        child: Center(
                          child: isLoading
                              ? LoadingIndicator()
                              : Icon(
                                  loginSuccess
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: 50,
                                ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: loginSuccess
                            ? [
                                green8DC640,
                                green476320,
                              ]
                            : isLoading
                                ? [
                                    yellowFBD400,
                                    yellow7E6A00,
                                  ]
                                : [
                                    redF55B31,
                                    red7B2E19,
                                  ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Visibility(
              visible: loginError != null && loginError.isNotEmpty,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                margin: const EdgeInsets.all(22.0),
                padding: const EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Text(
                  loginError ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
