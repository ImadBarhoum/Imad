import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '/config.dart';

class Version extends StatelessWidget {
  const Version({super.key});

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
                Container(padding: EdgeInsets.symmetric(horizontal: 30), child: Image.asset('assets/imgs/version.webp'),),
                SizedBox(height: 10),
                Center(child: Text('global_txt_9'.tr,style: TextStyle(fontSize: 22))),
                SizedBox(height: 10),
                Center(child: Text('global_txt_10'.tr,style: TextStyle(fontSize: 13))),
                SizedBox(height: 10),
                TextButton(
                  onPressed: (){
                    if (Platform.isAndroid || Platform.isIOS) {
                      final appId = Platform.isAndroid ? PACKAGE_NAME_APK : PACKAGE_NAME_IOS;
                      final url = Uri.parse(Platform.isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId");
                      launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text('global_txt_11'.tr,style: TextStyle(color: Colors.orangeAccent),),
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