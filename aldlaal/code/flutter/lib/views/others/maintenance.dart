import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image.asset(
              'assets/imgs/screen_bg.webp',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(padding: EdgeInsets.symmetric(horizontal: 30), child: Image.asset('assets/imgs/maintenance.webp'),),
                SizedBox(height: 10),
                Center(child: Text('global_txt_1'.tr,style: TextStyle(fontSize: 22))),
                SizedBox(height: 10),
                Center(child: Text('global_txt_2'.tr,style: TextStyle(fontSize: 13))),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async{
                    var res = await apiService('/app_check',{});
                    if (res != null && res['status'] == 1 && res['data']['maintenance'] == 0) {
                      String route = await getFirstRoute();
                      Get.offAllNamed(route);
                    }else{
                      Get.snackbar('sorry!'.tr, 'global_txt_3'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                    }
                  },
                  child: Text('try_again'.tr,style: TextStyle(color: Colors.orangeAccent)),
                  style: TextButton.styleFrom(foregroundColor: Colors.orangeAccent),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
