import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '/services/api_service.dart';

class LoginWithWp extends StatefulWidget {
  const LoginWithWp({super.key});

  @override
  State<LoginWithWp> createState() => _LoginWithWpState();
}

class _LoginWithWpState extends State<LoginWithWp> {
  late bool _isLoading = false;
  CountryCode phone_code = CountryCode.fromCountryCode('SY'); // phone num code
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();
  late int step = 0;
  int _seconds = 59;
  bool _isButtonDisabled = false;
  Timer? _timer;

  final defaultPinTheme = PinTheme(
    width: 48,
    height: 48,
    textStyle: TextStyle(fontSize: 24, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Color.fromRGBO(222, 231, 240, .57),
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          _timer?.cancel();
          _isButtonDisabled = false;
          _seconds = 59;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text('global_txt_48'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 10.0),
                    step == 0 ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('settings_txt_6'.tr, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Card(
                              color: Color(0xFFF1F2F4),
                              elevation: 0,
                              margin: box.read('lang') == 'en' ? EdgeInsets.fromLTRB(0, 0, 12, 0) : EdgeInsets.fromLTRB(12, 0, 0, 0),
                              child: CountryCodePicker(
                                onChanged: (CountryCode countryCode) {
                                  setState(() {phone_code = countryCode;});
                                },
                                initialSelection: phone_code.name,
                                showCountryOnly: false,
                                hideSearch: true,
                                hideMainText: true,
                                favorite: ['SY','JO','SA','AE','QA','EG','IR','PS','KW','BH','OM','YE','LB','DZ','TN','MA','SD','MR','TR','US','GB'],
                                /*countryList: [
                                  {"name": "syria".tr, "code": "SY", "dial_code": "+963"},
                                  {"name": "jordan".tr, "code": "JO", "dial_code": "+962"},
                                  {"name": "ksa".tr, "code": "SA", "dial_code": "+966"},
                                  {"name": "uae".tr, "code": "AE", "dial_code": "+971"},
                                  {"name": "qatar".tr, "code": "QA", "dial_code": "+974"},
                                  {"name": "egypt".tr, "code": "EG", "dial_code": "+20"},
                                  {"name": "iraq".tr, "code": "IR", "dial_code": "+964"},
                                  {"name": "palestine".tr, "code": "PS", "dial_code": "+970"},
                                  {"name": "kuwait".tr, "code": "KW", "dial_code": "+965"},
                                  {"name": "bahrain".tr, "code": "BH", "dial_code": "+973"},
                                  {"name": "oman".tr, "code": "OM", "dial_code": "+968"},
                                  {"name": "yemen".tr, "code": "YE", "dial_code": "+967"},
                                  {"name": "lebanon".tr, "code": "LB", "dial_code": "+961"},
                                  {"name": "algeria".tr, "code": "DZ", "dial_code": "+213"},
                                  {"name": "libya".tr, "code": "LY", "dial_code": "+218"},
                                  {"name": "tunisia".tr, "code": "TN", "dial_code": "+216"},
                                  {"name": "morocco".tr, "code": "MA", "dial_code": "+212"},
                                  {"name": "sudan".tr, "code": "SD", "dial_code": "+249"},
                                  {"name": "mauritania".tr, "code": "MR", "dial_code": "+222"},
                                ],*/
                                padding: const EdgeInsets.fromLTRB(10,8,0,8),
                                dialogItemPadding: const EdgeInsets.fromLTRB(10,10,10,10),
                                dialogSize: Size(250, 400),
                                flagWidth: 45,
                                enabled: true,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: phone,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'phone_number'.tr,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none,),
                                  filled: true, fillColor: const Color(0xFFF1F2F4),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                                autofocus: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text('global_txt_49'.tr, style: TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 25),
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
                            onPressed: () async{
                              if(phone.text.trim().isNotEmpty){
                                if(phone.text.length >= 7){
                                  var res = await apiService('/send_phone_otp', {'phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}",'type':'reset'});
                                  if (res != null && res['status'] == 1) {
                                    _startTimer();
                                    otp.text = "";
                                    setState(() {step=1;});
                                  }else if(res != null && res['status'] == 3){ // otp still valid
                                    Get.snackbar('sorry!'.tr, 'global_txt_29'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }else if(res != null && res['status'] == 5){ // phone exist
                                    Get.snackbar('sorry!'.tr, 'global_txt_43'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }else if(res != null && res['status'] == 4){ // mailer prb
                                    Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }
                                }else{
                                  Get.snackbar('sorry!'.tr, 'global_txt_44'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else{
                                Get.snackbar('sorry!'.tr, 'global_txt_45'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                            child: Text('send'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),),
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
                      ],
                    ):
                    step == 1 ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('global_txt_47'.tr, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
                        const SizedBox(height: 30.0),
                        /*TextFormField(
                          controller: otp,
                          decoration: InputDecoration(
                            labelText: 'global_txt_50'.tr,
                            hintText: 'global_txt_50'.tr,
                            prefixIcon: const Icon(Icons.attach_email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0),),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                            ),
                          ),
                        ),*/
                        Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              autofocus: true,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              onCompleted: (pin) async{
                                if(phone.text.trim().isNotEmpty){
                                  var res = await apiService('/user_login_phone', {'phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}",'otp':pin});
                                  if (res != null && res['status'] == 1) {
                                    box.write('user', res['data']['user']);
                                    box.write('token', res['token']);
                                    await fetch_user_data();
                                    apiService('/user/settings/update_fcm', {'fcm':box.read('fcm_token')});
                                    Get.offAllNamed('/home');
                                  }else if(res != null && res['status'] == 2){ // invalid code
                                    Get.snackbar('sorry!'.tr, 'global_txt_31'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }else{
                                    Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }
                                }else{
                                  Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        /*SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            onPressed: () async{
                              if(phone.text.trim().isNotEmpty && otp.text.trim().isNotEmpty){
                                var res = await apiService('/user_login_phone', {'phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}",'otp':otp.text});
                                if (res != null && res['status'] == 1) {
                                  box.write('user', res['data']['user']);
                                  box.write('token', res['token']);
                                  await fetch_user_data();
                                  apiService('/user/settings/update_fcm', {'fcm':box.read('fcm_token')});
                                  Get.offAllNamed('/home');
                                }else if(res != null && res['status'] == 2){ // invalid code
                                  Get.snackbar('sorry!'.tr, 'global_txt_31'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }else{
                                  Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else{
                                Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                            child: Text('login'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),),
                          ),
                        ),*/
                        const SizedBox(height: 15),
                        Center(
                            child: TextButton(
                              onPressed: _isButtonDisabled ? null : () async {
                                _startTimer();
                                await apiService('/send_phone_otp', {'phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}",'type':'reset'});
                              },
                              child: Text(
                                  _isButtonDisabled ? "${'global_txt_54'.tr} ($_seconds)" : 'global_txt_54'.tr,
                                  style: TextStyle(fontSize: 14, color: _isButtonDisabled ? Colors.grey : Colors.lightBlue)),
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  step = 0;
                                });
                              },
                              child: Text(
                                'back'.tr,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ) : Container()



                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}




