import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();

  Future<void> Login() async {
    if(email.text.trim().isNotEmpty && pwd.text.trim().isNotEmpty){
      var res = await apiService('/login', {'email':email.text,'pwd':pwd.text,'role':'user'});
      if (res != null && res['status'] == 1) {
        box.write('user', res['data']['user']);
        box.write('token', res['token']);
        await fetch_user_data();
        apiService('/user/settings/update_fcm', {'fcm':box.read('fcm_token')});
        Get.offAllNamed('/home');
      }else{
        Get.snackbar('sorry!'.tr, 'global_txt_23'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
      }
    }else{
      Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 77,
        title: Image.asset('assets/logo_white.png',height: 50),
        centerTitle: true,
        backgroundColor: Color(0xff1f3c5a),
        elevation: 0,
        actions: [],
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.white),
          onPressed: () {Get.back();},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xff1f3c5a),
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 6),
            ),
            const SizedBox(height: 40.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
              child: Column(
                children: [
                  Text(
                    'global_txt_22'.tr,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  Text(
                    'global_txt_21'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'global_txt_20'.tr,
                      hintText: 'global_txt_19'.tr,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: pwd,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'global_txt_18'.tr,
                      hintText: 'global_txt_17'.tr,
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),


                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/auth/reset');
                        //Get.snackbar('sorry!'.tr, 'soon'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                      },
                      child: Text(
                        'global_txt_16'.tr,
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1f3c5a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () async {
                        await Login();
                      },
                      child: Text(
                        'global_txt_15'.tr,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("global_txt_14".tr),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/auth/register');
                        },
                        child: Text(
                          'global_txt_101'.tr,
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(color: Colors.grey.shade300, thickness: 1, indent: 10, endIndent: 10),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF67D449),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      onPressed: () async {
                        Get.toNamed('/auth/login_with_wp');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.phone,size: 25,color: Colors.white,),
                          const SizedBox(width: 10.0),
                          Text(
                            'global_txt_42'.tr,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
