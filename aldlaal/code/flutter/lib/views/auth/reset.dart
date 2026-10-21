import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController otp = TextEditingController();
  late int step = 0;


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
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Text('global_txt_32'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    step == 0 ? Column(
                      children: [
                        Text('global_txt_34'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 10),
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
                              if(email.text.trim().isNotEmpty){
                                var res = await apiService('/send_email_otp', {'email':email.text,'role':'user','type':'reset'});
                                if (res != null && res['status'] == 1) {
                                  setState(() {step=1;});
                                }else if(res != null && res['status'] == 3){ // otp still valid
                                  Get.snackbar('sorry!'.tr, 'global_txt_29'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }else if(res != null && res['status'] == 5){ // email not found
                                  Get.snackbar('sorry!'.tr, 'global_txt_35'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }else if(res != null && res['status'] == 4){ // mailer prb
                                  Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else{
                                Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                            child: Text('send'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),),
                          ),
                        ),
                      ],
                    ):
                    step == 1 ? Column(
                      children: [
                        Text('global_txt_25'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: otp,
                          decoration: InputDecoration(
                            labelText: 'global_txt_26'.tr,
                            hintText: 'global_txt_26'.tr,
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
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: pwd,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'global_txt_33'.tr,
                            hintText: 'global_txt_33'.tr,
                            prefixIcon: const Icon(Icons.lock),
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
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
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
                              if(email.text.trim().isNotEmpty && pwd.text.trim().isNotEmpty && otp.text.trim().isNotEmpty){
                                var res = await apiService('/reset_password', {'email':email.text,'pwd':pwd.text,'otp':otp.text,'role':'user'});
                                if (res != null && res['status'] == 1) {
                                  Get.back();
                                  Get.snackbar('success'.tr, 'global_txt_36'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                }else if(res != null && res['status'] == 4){ // pwd less then 8 char
                                  Get.snackbar('sorry!'.tr, 'global_txt_30'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }else if(res != null && res['status'] == 6){ // invalid code
                                  Get.snackbar('sorry!'.tr, 'global_txt_31'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else{
                                Get.snackbar('sorry!'.tr, 'global_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                            child: Text('apply'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),),
                          ),
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
