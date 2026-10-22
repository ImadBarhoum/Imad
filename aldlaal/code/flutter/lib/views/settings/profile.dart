import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();
  String state = '';
  String city = '';
  dynamic states = [];
  dynamic citys = [];

  Future<void> getStates() async{
    var res = await apiService('/others/get_states', {});
    if(res != null && res['status'] == 1){
      setState(() {states = res['data'];});
    }
  }
  Future<void> getCitys() async{
    setState(() {city = '';});
    var res = await apiService('/others/get_citys', {'state': state});
    if(res != null && res['status'] == 1){
      setState(() {citys = res['data'];});
    }
  }

  void Logout(){
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(15,20,15,10),
        actionsPadding: const EdgeInsets.fromLTRB(10,10,10,10),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,size: 40,color: Colors.black,),
        backgroundColor: Colors.white,
        title: Text('settings_txt_8'.tr),
        content: Text('settings_txt_9'.tr),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => logout(force: 1),
            child: Text("logout".tr),
          ),
        ],
      ),
    );
  }

  void DeleteAccount(){
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(15,20,15,10),
        actionsPadding: const EdgeInsets.fromLTRB(10,10,10,10),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,size: 40,color: Colors.black,),
        backgroundColor: Colors.white,
        title: Text('settings_txt_14'.tr),
        content: Text('settings_txt_15'.tr),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async{
              var res = await apiService('/user/settings/remove', {});
              if(res != null && res['status'] == 1){
                Get.snackbar('success'.tr, 'settings_txt_16'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                logout();
              }else{
                Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
              }
            },
            child: Text("delete".tr),
          ),
        ],
      ),
    );
  }

  void initFields() async{
    name.text = box.read('user_name');
    email.text = box.read('user_email');
    phone.text = box.read('user_phone');
    await getStates();
    state = box.read('user_state');
    await getCitys();
    city = box.read('user_city');
  }
  @override
  void initState() {
    initFields();
    super.initState();
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
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: phone,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(FontAwesomeIcons.phone),
                      label: Text('phone_number'.tr),
                      hintText: 'phone_number'.tr,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      filled: true, fillColor: const Color(0xFFF1F2F4),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(31),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      suffixIcon: Icon(FontAwesomeIcons.at),
                      label: Text('email'.tr),
                      hintText: 'email'.tr,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      filled: true, fillColor: const Color(0xFFF1F2F4),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(63),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(FontAwesomeIcons.user),
                      label: Text('name'.tr),
                      hintText: 'name'.tr,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      filled: true, fillColor: const Color(0xFFF1F2F4),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(31),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('state'.tr),
                      items: states.isNotEmpty ? [
                        for (var item in states)
                          DropdownMenuItem<String>(value: item['name_ar'].toString(), child: Text(item['name_ar'].toString() ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {state = value ?? '';});
                        getCitys();
                        },
                      value: state.isNotEmpty && states.any((item) => item['name_ar'].toString() == state) ? state : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('city'.tr),
                      items: citys.isNotEmpty ? [
                        for (var item in citys)
                          DropdownMenuItem<String>(value: item['name_ar'].toString(), child: Text(item['name_ar'].toString() ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          city = value ?? '';
                        });},
                      value: city.isNotEmpty && citys.any((item) => item['name_ar'].toString() == city) ? city : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        setState(() {_isLoading = true;});
                        if(name.text != '' && email.text != ''){
                          if(GetUtils.isEmail(email.text)){
                            var res = await apiService('/user/settings/edit',{
                              'name': name.text,
                              'phone': phone.text,
                              'state': state,
                              'city': city,
                            });
                            if(res != null && res['status'] == 1){
                              fetch_user_data();
                              Get.snackbar('success'.tr, 'settings_txt_18'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                            }else{
                              Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                            }
                          }else{
                            Get.snackbar('sorry!'.tr, 'settings_txt_19'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                          }
                        }else{
                          Get.snackbar('sorry!'.tr, 'settings_txt_20'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                        }
                        setState(() {_isLoading = false;});
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0xff1f3c5a),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('save'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.blueGrey[200]),
                  const SizedBox(height: 5),


                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5 ,bottom: 5),
                    child: Row(
                        children: [
                          Icon(FontAwesomeIcons.rightFromBracket, size: 24, color: Colors.blueGrey[900],),
                          Container(
                            padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                            child: Text('settings_txt_17'.tr, style: const TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: (){Logout();},
                            child: Text('logout'.tr,style: TextStyle(color: Colors.redAccent)),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              //backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ]
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5 ,bottom: 5),
                    child: Row(
                        children: [
                          Icon(FontAwesomeIcons.userXmark, size: 24, color: Colors.blueGrey[900],),
                          Container(
                            padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                            child: Text('settings_txt_14'.tr, style: const TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: (){DeleteAccount();},
                            child: Text('delete'.tr,style: TextStyle(color: Colors.redAccent)),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              //backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ]
                    ),
                  ),


                ],
              ),
            )




          ],
        ),
      ),
    );
  }
}
