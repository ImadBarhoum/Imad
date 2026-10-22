import 'dart:io';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '/config.dart';
import '/services/api_service.dart';
import '/services/img_saver.dart';
import '/langs/local.dart';

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({super.key});

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  late String auth = box.hasData('auth') ? box.read('auth') : '0';
  Future<void> onBack() async {
    setState(() {
      auth = box.hasData('auth') ? box.read('auth') : '0';
    });
  }

  @override
  void initState() {
    super.initState();
    onBack();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      onRefresh: onBack,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xff1f3c5a),
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 6),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  auth == '1' ? ProfileCard() : NotLoginCard(),
                  //-------------------------------------
                  Divider(color: Colors.blueGrey[200]),
                  ProfileMenu(typee:'page',title: 'global_txt_86'.tr,icon: FontAwesomeIcons.buildingFlag,route: '/agency/search',onBack: onBack),
                  _buildDivider(),
                  auth == '1' ?
                  Column(
                    children: [
                      ProfileMenu(typee:'page',title: 'settings_txt_11'.tr,icon: FontAwesomeIcons.solidUser,route: '/settings/profile',onBack: onBack),
                      _buildDivider(),
                      ProfileMenu(typee:'page',title: 'settings_txt_41'.tr,icon: Icons.verified_sharp,route: '/settings/verify',onBack: onBack),
                      _buildDivider(),
                    ],
                  ) : Container(),
                  ProfileMenu(typee:'lang',title: 'settings_txt_1'.tr,icon: FontAwesomeIcons.language,route: '',onBack: onBack),
                  _buildDivider(),
                  //ProfileMenu(typee:'curr',title: 'settings_txt_13'.tr,icon: FontAwesomeIcons.coins,route: '',onBack: onBack),
                  ProfileMenu(typee:'page',title: 'settings_txt_2'.tr,icon: FontAwesomeIcons.circleInfo,route: '/others/about',onBack: onBack),
                  _buildDivider(),
                  ProfileMenu(typee:'contact',title: 'settings_txt_3'.tr,icon: FontAwesomeIcons.phone,route: '',onBack: onBack),
                  _buildDivider(),
                  ProfileMenu(typee:'page',title: 'settings_txt_4'.tr,icon: FontAwesomeIcons.shieldHalved,route: '/others/privacy',onBack: onBack),
                  _buildDivider(),
                  ProfileMenu(typee:'page',title: 'settings_txt_5'.tr,icon: FontAwesomeIcons.scroll,route: '/others/terms',onBack: onBack),
                  auth == '1' ? _buildDivider(): Container(),
                  //ProfileMenu(typee:'join_us',title: 'settings_txt_12'.tr,icon: FontAwesomeIcons.fileSignature,route: '',onBack: onBack),
                  auth == '1' ? ProfileMenu(typee:'logout',title: 'logout'.tr,icon: FontAwesomeIcons.rightFromBracket,route: '',onBack: onBack):Container(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(Platform.isAndroid ? 'v${APP_VERSION_APK}' : 'v${APP_VERSION_IOS}'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class NotLoginCard extends StatelessWidget {
  const NotLoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 15,left: 10,right: 10),
      child: Row(
        children: [
          Text('settings_txt_6'.tr,style: TextStyle(fontSize: 18),),
          Spacer(),
          Container(
            width: 130,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xff1f3c5a), width: 1,),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Color(0xff1f3c5a),
              ),
              onPressed: () {
                Get.toNamed('/auth/login');
              },
              child: Text('login'.tr, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
            ),
          )
        ],
      ),
    );
  }
}


class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}
class _ProfileCardState extends State<ProfileCard> {
  late String name = box.hasData('user_name') ? box.read('user_name') : '';
  late String img = box.hasData('user_img') ? box.read('user_img') : '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 25,bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(blurRadius: 15, color: Colors.grey, spreadRadius: 1)],
              ),
              child: Material(
                shape: const CircleBorder(),
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async{
                    var img_name = await ImageSaver().Save();
                    if(img_name != null){
                      var res = await apiService('/user/settings/edit_img', {'img':img_name});
                      if(res != null && res['status'] == 1){
                        setState(() {img = img_name;});
                        box.write('user_img', img_name);
                        Get.snackbar('success'.tr, 'settings_txt_10'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                      }else{
                        Get.snackbar('sorry!'.tr, 'settings_txt_7'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: img != ''
                        ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/$img', imageBuilder: (context, imageProvider) => CircleAvatar(radius: 75, backgroundImage: imageProvider,backgroundColor: Colors.white,), placeholder: (context, url) => Container(padding: EdgeInsets.all(20),child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 3,)), errorWidget: (context, url, error) => Image.asset('assets/imgs/av.webp'))
                        : const CircleAvatar(radius: 75, backgroundImage: AssetImage('assets/imgs/av.webp'),backgroundColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(name, style: const TextStyle(fontSize: 23)),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildDivider() => Divider(height: 1, indent: 15, endIndent: 15, color: Colors.grey[200]);

class ProfileMenu extends StatefulWidget {
  final VoidCallback onBack;
  final IconData icon;
  final String typee;
  final String title;
  final String route;
  const ProfileMenu({required this.typee,required this.icon, required this.title, required this.route, required this.onBack});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}
class _ProfileMenuState extends State<ProfileMenu> {
  final LocaleController localeController = Get.find();
  final String phone = box.hasData('settings_site_phone') ? box.read('settings_site_phone') : '';
  final String email = box.hasData('settings_site_email') ? box.read('settings_site_email') : '';
  final String fb = box.hasData('settings_sociel_fb') ? box.read('settings_sociel_fb') : '';
  final String insta = box.hasData('settings_sociel_insta') ? box.read('settings_sociel_insta') : '';
  final String whats = box.hasData('settings_sociel_whats') ? box.read('settings_sociel_whats') : '';
  final String youtube = box.hasData('settings_sociel_youtube') ? box.read('settings_sociel_youtube') : '';
  final String tiktok = box.hasData('settings_sociel_tiktok') ? box.read('settings_sociel_tiktok') : '';
  final String x = box.hasData('settings_sociel_x') ? box.read('settings_sociel_x') : '';

  void Contact(){

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(FontAwesomeIcons.solidCircleQuestion, size: 24, color: Colors.blueGrey[900]),
                      SizedBox(width: 8),
                      Text('settings_txt_3'.tr,style: TextStyle(fontSize: 22)),
                      Spacer(),
                      IconButton(icon: Icon(FontAwesomeIcons.close,size: 28,color: Colors.blueGrey[900]), onPressed: () {Get.back();}),
                    ],
                  ),
                  const SizedBox(height: 10),
                  phone != '' ? InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(phone,style: const TextStyle(fontSize: 28))
                        ),
                        const SizedBox(width: 15),
                        Icon(FontAwesomeIcons.phone,size: 35,color: Colors.blueGrey[900]),
                      ],
                    ),
                    onTap: () async {
                      var url = 'tel:${phone}';
                      if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));}
                    },
                  ):Container(),
                  const SizedBox(height: 5),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fb != '' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(icon: const Icon(FontAwesomeIcons.facebook,size: 30,color: Colors.blueAccent),
                          onPressed: () async {
                            var url = fb;
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
                          },
                        ),
                      ):Container(),
                      insta != '' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(icon: const Icon(FontAwesomeIcons.instagram,size: 30,color: Color(0xFFF00879)),
                          onPressed: () async {
                            var url = insta;
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
                          },
                        ),
                      ):Container(),
                      x != '' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(icon: const Icon(FontAwesomeIcons.xTwitter,size: 30,color: Colors.black),
                          onPressed: () async {
                            var url = x;
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
                          },
                        ),
                      ):Container(),
                      tiktok != '' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(icon: Icon(FontAwesomeIcons.tiktok,size: 30,color: Colors.blueGrey[900]),
                          onPressed: () async {
                            var url = tiktok;
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
                          },
                        ),
                      ):Container(),
                      youtube != '' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(icon: const Icon(FontAwesomeIcons.youtube,size: 30,color: Colors.redAccent),
                          onPressed: () async {
                            var url = youtube;
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
                          },
                        ),
                      ):Container(),
                      whats != '' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(icon: const Icon(FontAwesomeIcons.whatsapp,size: 30,color: Colors.lightGreen),
                          onPressed: () async {
                            var url = "https://wa.me/${whats}";
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
                          },
                        ),
                      ):Container(),
                    ],
                  ),



                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void Lang(){
    final lang = localeController.locale.value?.languageCode;
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(FontAwesomeIcons.language, size: 24, color: Colors.blueGrey[900]),
                      SizedBox(width: 8),
                      Text('settings_txt_1'.tr,style: TextStyle(fontSize: 22)),
                      Spacer(),
                      IconButton(icon: Icon(FontAwesomeIcons.close,size: 28,color: Colors.blueGrey[900]), onPressed: () {Get.back();}),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: lang == 'ar' ? Colors.blueAccent : Colors.grey, width: 1,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: lang == 'ar' ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            ),
                            onPressed: lang == 'en' ? () {
                              localeController.updateLocale('ar');
                              apiService('/user/settings/update_lang', {});
                              Get.back();
                            } : null,
                            child: Text('arabic'.tr, style: TextStyle(color: Colors.blueGrey.shade900,fontWeight: FontWeight.bold,fontSize: 16)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: lang == 'en' ? Colors.blueAccent : Colors.grey, width: 1,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: lang == 'en' ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            ),
                            onPressed: lang == 'ar' ? () {
                              localeController.updateLocale('en');
                              apiService('/user/settings/update_lang', {});
                              Get.back();
                            } : null,
                            child: Text('english'.tr, style: TextStyle(color: Colors.blueGrey.shade900,fontWeight: FontWeight.bold,fontSize: 16),),
                          ),
                        ),
                      ),
                    ],
                  ),




                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void Curr(){
    final curr = box.hasData('currency') ? box.read('currency') : 'SYP';
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(FontAwesomeIcons.coins, size: 24, color: Colors.blueGrey[900]),
                      SizedBox(width: 8),
                      Text('settings_txt_13'.tr,style: TextStyle(fontSize: 22)),
                      Spacer(),
                      IconButton(icon: Icon(FontAwesomeIcons.close,size: 28,color: Colors.blueGrey[900]), onPressed: () {Get.back();}),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: curr == 'USD' ? Colors.blueAccent : Colors.grey, width: 1,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: curr == 'USD' ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            ),
                            onPressed: curr == 'SYP' ? () {
                              box.write('currency', 'USD');
                              Get.back();
                            } : null,
                            child: Text('USD', style: TextStyle(color: Colors.blueGrey.shade900,fontWeight: FontWeight.bold,fontSize: 16)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: curr == 'SYP' ? Colors.blueAccent : Colors.grey, width: 1,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: curr == 'SYP' ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            ),
                            onPressed: curr == 'USD' ? () {
                              box.write('currency', 'SYP');
                              Get.back();
                            } : null,
                            child: Text('SYP', style: TextStyle(color: Colors.blueGrey.shade900,fontWeight: FontWeight.bold,fontSize: 16),),
                          ),
                        ),
                      ),
                    ],
                  ),




                ],
              ),
            ),
          ),
        );
      },
    );

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
            onPressed: () => logout(),
            child: Text("logout".tr),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(widget.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      leading: Icon(widget.icon, size: 24, color: Colors.blueGrey.shade900),
      onTap: () async{
        if(widget.typee == 'page'){
          Get.toNamed(widget.route)!.then((_){
            widget.onBack();
          });
        }else if(widget.typee == 'contact'){
          Contact();
        }else if(widget.typee == 'lang'){
          Lang();
        }else if(widget.typee == 'curr'){
          Curr();
        }else if(widget.typee == 'logout'){
          Logout();
        }else if(widget.typee == 'join_us'){
          var url = "${DOMAIN_URL}/login";
          if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
        }
      },
    );
    /*return InkWell(
      onTap: () async{
        if(widget.typee == 'page'){
          Get.toNamed(widget.route)!.then((_){
            widget.onBack();
          });
        }else if(widget.typee == 'contact'){
          Contact();
        }else if(widget.typee == 'lang'){
          Lang();
        }else if(widget.typee == 'curr'){
          Curr();
        }else if(widget.typee == 'logout'){
          Logout();
        }else if(widget.typee == 'join_us'){
          var url = "${DOMAIN_URL}/login";
          if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);}
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20 ,bottom: 20),
        child: Row(
            children: [
              Icon(widget.icon, size: 24, color: Colors.blueGrey.shade900),
              Container(
                padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Text(widget.title, style: const TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ]
        ),
      ),
    );*/
  }
}










