import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class Offline extends StatelessWidget {
  const Offline({super.key});

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
                Container(padding: EdgeInsets.symmetric(horizontal: 75), child: Image.asset('assets/imgs/offline.webp'),),
                SizedBox(height: 40),
                Center(child: Text('global_txt_5'.tr,style: TextStyle(fontSize: 22))),
                SizedBox(height: 10),
                Center(child: Text('global_txt_6'.tr,style: TextStyle(fontSize: 13))),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async{
                    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
                    if(connectivityResult.contains(ConnectivityResult.none)){
                      Get.snackbar('sorry!'.tr, 'global_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                    }else{
                      String route = await getFirstRoute();
                      Get.offAllNamed(route);
                    }
                  },
                  child: Text('try_again'.tr,style: TextStyle(color: Colors.orangeAccent),),
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