import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/config.dart';
GetStorage box = GetStorage();


Future<dynamic> apiService(String param,dynamic data,{int timeout=10}) async {
  String token = box.hasData('token') ? box.read('token') : '';
  String lang = box.hasData('lang') ? box.read('lang') : 'ar';
  String device = Platform.isIOS ? 'ios':'android';
  try {
    final response = await http.post(
      Uri.parse('${API_URL}${param}'),
      headers: {"Content-Type": "application/json","Authorization": "${token}","lang":"${lang}","device":"${device}"},
      body: jsonEncode(data),
    ).timeout(Duration(seconds: timeout));
    if (response.statusCode == 200 && response.headers['content-type']?.contains('application/json') == true) {
      return jsonDecode(response.body);
    } else {print('# Error Status code: ${response.statusCode}');return null;}
  } catch (e) {print('# Error on catch! $e'); return null;}
}


// CHECK IF USER LOGIN OR NOT
Future<dynamic> checkLogin() async{
  var res = await apiService('/check',{});
  if(res != null && res['status'] == 1){
    return true;
  }else{
    return false;
  }
}


// GET FIRST ROUTE
Future<String> getFirstRoute() async {
  final appVersion = Platform.isAndroid ? APP_VERSION_APK : APP_VERSION_IOS;
  final miniAppVersion = Platform.isAndroid ? 'mini_version_apk' : 'mini_version_ios';
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult.contains(ConnectivityResult.none)){
    return '/others/offline';
  }else{
    var res = await apiService('/app_check', {});
    if (res == null || res['status'] != 1 || res['data']['maintenance'] == 1) {return '/others/maintenance';}
    if (double.parse(appVersion) < double.parse(res['data'][miniAppVersion])) {
      return '/others/version';
    }else{
      await fetch_settings_data();
      apiService('/user/settings/update_fcm', {'fcm':box.read('fcm_token')});
      if(box.hasData('skip_first_time_screen') && box.read('skip_first_time_screen') == '1'){
        return '/home';
      }else{
        return '/introduction';
      }
    }
  }
}


Future<void> fetch_settings_data() async{
  var res = await apiService('/get_settings',{});
  if(res != null && res['status'] == 1){
    if(!box.hasData('uuid')){box.write('uuid', getRandString(20));}
    var app = res['app'];
    box.write('settings_site_name',app['site_name']);
    box.write('settings_site_description',app['site_description']);
    box.write('settings_site_email',app['site_email']);
    box.write('settings_site_phone',app['site_phone']);
    box.write('settings_subscription',app['subscription']);
    box.write('settings_sociel_fb',app['sociel_fb']);
    box.write('settings_sociel_insta',app['sociel_insta']);
    box.write('settings_sociel_whats',app['sociel_whats']);
    box.write('settings_sociel_youtube',app['sociel_youtube']);
    box.write('settings_sociel_tiktok',app['sociel_tiktok']);
    box.write('settings_sociel_x',app['sociel_x']);
    box.write('exchange',app['exchange']);
    box.write('map_url',app['map_url']);
    await fetch_user_data();
  }
}


// Fetch client data
Future<void> fetch_user_data() async{
  var res = await apiService('/user/settings/get_user',{});
  if(res != null && res['status'] == 1){
    var user = res['user'];
    box.write('auth','1');
    box.write('user_id',user['id'].toString());
    box.write('user_name',user['name']);
    box.write('user_phone',user['phone']);
    box.write('user_email',user['email']);
    box.write('user_img',user['img']);
    box.write('user_city',user['city']);
    box.write('user_state',user['state']);
  }else{
    box.write('auth','0');
  }
}


// LOGOUT
Future<void> logout({int force = 0}) async {
  var lang = box.read('lang');
  var uuid = box.read('uuid');
  if(force == 1){await apiService('/force_logout',{});}
  box.erase();
  box.write('skip_first_time_screen', '1');
  box.write('uuid', uuid);
  box.write('lang', lang);
  fetch_settings_data();
  Get.offAllNamed('/home');
}

//


void saveWithExpiry({
  required String key,
  required dynamic value,
  required Duration expiryDuration,
}) {
  final data = {
    'value': value,
    'expiry': DateTime.now().add(expiryDuration).toIso8601String(),
  };
  box.write(key, data);
}

dynamic readWithExpiry(String key) {
  final data = box.read(key);
  if (data == null || data is! Map) return null;
  final expiry = DateTime.tryParse(data['expiry'] ?? '');
  if (expiry == null || DateTime.now().isAfter(expiry)) {
    box.remove(key);
    return null;
  }
  return data['value'];
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) =>  random.nextInt(255));
  return base64UrlEncode(values);
}