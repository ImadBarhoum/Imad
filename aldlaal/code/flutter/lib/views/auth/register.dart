import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '/services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool _isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController otp = TextEditingController();
  CountryCode phone_code = CountryCode.fromCountryCode('SY'); // phone num code
  late int step = 0;
  late int register_with = 0;
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
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                child: Column(
                  children: [
                    step != 2 ? Column(
                      children: [
                        const SizedBox(height: 30),
                        Text('settings_txt_21'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 10.0),
                        Text('settings_txt_22'.tr, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
                        const SizedBox(height: 40.0),
                      ],
                    ):Container(),

                    step == 0 ? Column(
                      children: [


                        Row(
                          children: [
                            Expanded(child: ElevatedButton(
                              onPressed: () {setState(() {register_with = 0;});},
                              child: Text("global_txt_99".tr),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: register_with == 0 ? Color(0xff1f3c5a) : Color(0xFFF1F2F4),
                                foregroundColor: register_with == 0 ? Colors.white : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )),
                            SizedBox(width: 5),
                            Expanded(child: ElevatedButton(
                              onPressed: () {setState(() {register_with = 1;});},
                              child: Text("global_txt_100".tr),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: register_with == 1 ? Color(0xff1f3c5a) : Color(0xFFF1F2F4),
                                foregroundColor: register_with == 1 ? Colors.white : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )),
                        ]),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'name'.tr,
                            hintText: 'name'.tr,
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none,),
                            filled: true, fillColor: const Color(0xFFF1F2F4),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        register_with == 0 ? Row(
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
                                favorite: ['SY','JO','SA','AE','QA','EG','IR','PS','KW','BH','OM','YE','LB','DZ','TN','MA','SD','MR'],
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
                                autofocus: false,
                              ),
                            ),
                          ],
                        ) :
                        register_with == 1 ? Column(
                          children: [
                            TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'email'.tr,
                                hintText: 'email'.tr,
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none,),
                                filled: true, fillColor: const Color(0xFFF1F2F4),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: pwd,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'global_txt_18'.tr,
                                hintText: 'global_txt_18'.tr,
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none,),
                                filled: true, fillColor: const Color(0xFFF1F2F4),
                              ),
                            ),
                          ],
                        ) : Container(),
                        const SizedBox(height: 40),
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
                              if(register_with == 0){
                                if(phone.text.trim().isNotEmpty && name.text.trim().isNotEmpty){
                                  //if(pwd.text.length >= 8){
                                  var res = await apiService('/send_phone_otp', {'phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}"});
                                  if (res != null && res['status'] == 1) {
                                    _startTimer();
                                    setState(() {step=1;});
                                    //Get.back();
                                    //Get.snackbar('success'.tr, 'global_txt_27'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                  }else if(res != null && res['status'] == 3){ // otp still valid
                                    Get.snackbar('sorry!'.tr, 'global_txt_29'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }else if(res != null && res['status'] == 5){ // email exist
                                    Get.snackbar('sorry!'.tr, 'global_txt_94'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }else if(res != null && res['status'] == 4){ // mailer prb
                                    Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }
                                  /*}else{
                                  Get.snackbar('sorry!'.tr, 'global_txt_30'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }*/
                                }else{
                                  Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else if(register_with == 1){
                                if(email.text.trim().isNotEmpty && name.text.trim().isNotEmpty){
                                  if(pwd.text.length >= 8){
                                    var res = await apiService('/send_email_otp', {'email':email.text});
                                    if (res != null && res['status'] == 1) {
                                      _startTimer();
                                      setState(() {step=1;});
                                      //Get.back();
                                      //Get.snackbar('success'.tr, 'global_txt_27'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 3){ // otp still valid
                                      Get.snackbar('sorry!'.tr, 'global_txt_29'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 5){ // email exist
                                      Get.snackbar('sorry!'.tr, 'global_txt_28'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 4){ // mailer prb
                                      Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }
                                  }else{
                                    Get.snackbar('sorry!'.tr, 'global_txt_30'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }
                                }else{
                                  Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }
                            },
                            child: Text('global_txt_101'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),),
                          ),
                        ),
                      ],
                    ):
                    step == 1 ? Column(
                      children: [
                        Text(register_with == 0 ? 'global_txt_47'.tr : 'global_txt_25'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 25),
                        Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              autofocus: true,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              onCompleted: (pin) async{
                                if(register_with == 0){
                                  if(phone.text.trim().isNotEmpty && name.text.trim().isNotEmpty){
                                    var res = await apiService('/register', {'email':'','pwd':'','phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}",'name':name.text,'otp':pin,'type':'phone'});
                                    if (res != null && res['status'] == 1) {
                                      setState(() {step=2;});
                                      //Get.back();
                                      Get.snackbar('success'.tr, 'global_txt_27'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 2){ // email not valid
                                      Get.snackbar('sorry!'.tr, 'settings_txt_19'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 3){ // email exist
                                      Get.snackbar('sorry!'.tr, 'global_txt_28'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 4){ // mailer prb
                                      Get.snackbar('sorry!'.tr, 'global_txt_30'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 6){ // invalid code
                                      Get.snackbar('sorry!'.tr, 'global_txt_31'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }
                                  }else{
                                    Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }
                                }else if(register_with == 1){
                                  if(email.text.trim().isNotEmpty && pwd.text.trim().isNotEmpty && name.text.trim().isNotEmpty){
                                    var res = await apiService('/register', {'email':email.text,'pwd':pwd.text,'phone':'','name':name.text,'otp':pin,'type':'email'});
                                    if (res != null && res['status'] == 1) {
                                      setState(() {step=2;});
                                      //Get.back();
                                      Get.snackbar('success'.tr, 'global_txt_27'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 2){ // email not valid
                                      Get.snackbar('sorry!'.tr, 'settings_txt_19'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 3){ // email exist
                                      Get.snackbar('sorry!'.tr, 'global_txt_28'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 4){ // mailer prb
                                      Get.snackbar('sorry!'.tr, 'global_txt_30'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }else if(res != null && res['status'] == 6){ // invalid code
                                      Get.snackbar('sorry!'.tr, 'global_txt_31'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                    }
                                  }else{
                                    Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: TextButton(
                              onPressed: _isButtonDisabled ? null : () async {
                                _startTimer();
                                if(register_with == 0){
                                  await apiService('/send_phone_otp', {'phone':phone.text.startsWith('0') ? "${phone_code}${phone.text.substring(1)}" : "${phone_code}${phone.text}"});
                                }else if(register_with == 1){
                                  await apiService('/send_email_otp', {'email':email.text});
                                }
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
                    ) :
                    step == 2 ? Column(
                      children: [
                        const SizedBox(height: 80),
                        Image.asset('assets/imgs/success.webp',width: 150),
                        const SizedBox(height: 15),
                        Text('global_txt_95'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 10),
                        Text('global_txt_96'.tr, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1f3c5a),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            onPressed: () async {Get.back();},
                            child: Text(
                              'login'.tr,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
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










