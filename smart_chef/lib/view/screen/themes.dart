import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/share_preferance.dart';

class Themes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeGet homeGet = Get.find();
    return Obx(() {
      print(homeGet.dashpordThemes.value);
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: Row(
                children: [
                  InkWell(
                      onTap: ()async {
                        homeGet.dashpordThemes.value = 1;
                        await ShereHelper.sHelper.addNew("theme", "1");

                      },
                      child:
                          theme("Theme 1", "assets/images/dashpord1.png", 1)),
                  Spacer(),
                  InkWell(
                      onTap: () async{
                        homeGet.dashpordThemes.value = 2;
                        await ShereHelper.sHelper.addNew("theme", "2");

                      },
                      child:
                          theme("Theme 2", "assets/images/dashpord2.png", 2)),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
                onTap: ()async {
                  homeGet.dashpordThemes.value = 3;
await ShereHelper.sHelper.addNew("theme", "3");
                },
                child: theme("Theme 3", "assets/images/dashpord3.png", 3)),
          ),
        ],
      );
    });
  }

  Widget theme(String title, String urlImg, int index) {
    HomeGet homeGet = Get.find();

    return Container(
        width: 470,
        child: Column(
          children: [
            Row(
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 20,
                        color: homeGet.dashpordThemes.value == index
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.w700)),
                Spacer(),
                Radio(
                  value: index,
                  onChanged: (value) {
                    homeGet.dashpordThemes.value = value;
                  },
                  activeColor: Colors.green,
                  groupValue: homeGet.dashpordThemes.value,
                )
              ],
            ),
            homeGet.dashpordThemes.value == index
                ? Image.asset(
                    urlImg,
                    colorBlendMode: BlendMode.lighten,
                    color: Colors.black.withOpacity(0.4),
                  )
                : Image.asset(
                    urlImg,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.4),
                  ),
          ],
        ));
  }
}
