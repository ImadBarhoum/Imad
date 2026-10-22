import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';


class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});
  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late bool _isLoading = true;
  late String content = '';
  Future<void> getData() async {
    setState(() {_isLoading = true;});
    var res = await apiService('/others/get_page', {'slug':'privacy'});
    if(res != null && res['status'] == 1){
      setState(() {
        content = res['data']['content'];
      });
    }
    setState(() {_isLoading = false;});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('global_txt_4'.tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blueGrey.withOpacity(0.2),
        elevation: 8,
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.blueGrey.shade900),
          onPressed: () {Get.back();},
        ),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: !_isLoading ? Html(data: content) : Center(child: Container(width: 75, height: 75, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3))),
          ),
        ),
      ),
    );
  }
}