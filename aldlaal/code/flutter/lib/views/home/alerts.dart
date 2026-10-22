import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late dynamic alerts = [];

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/user/alerts/get_page', {'page':page});
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 12) finalPage = true;
        page == 1 ? alerts = res['data'] : alerts.addAll(res['data']);
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }

  @override
  void initState() {
    super.initState();
    getData();
    _loadMoreController.addListener(() {if (_loadMoreController.offset == _loadMoreController.position.maxScrollExtent) {getData(skip: 1);}});
  }

  @override
  void dispose() {
    _loadMoreController.dispose();
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
      body: RefreshIndicator(
        color: Color(0xff1f3c5a),
        backgroundColor: Colors.white,
        onRefresh: getData,
        child: SingleChildScrollView(
          controller: _loadMoreController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Color(0xff1f3c5a),
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 6),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    !_isLoading && alerts.length != 0 ?
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: alerts.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: AlertCard(
                                id: alerts[i]['id'].toString(),
                                title: alerts[i]['title'],
                                search_json: alerts[i]['search_json'],
                                notification_email: alerts[i]['notification_email'],
                                notification_app: alerts[i]['notification_app'],
                                onRefresh: getData,
                              ),
                            );
                          },
                        ),
                        _isLoadMore ? Center(child: Container(width: 30, height: 30, margin: EdgeInsets.only(top: 5,bottom: 20), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2))) : Container(),
                      ],
                    ) :
                    !_isLoading && alerts.length == 0 ? Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Container(width: 250,child: Image.asset('assets/imgs/no_notification.webp')),
                            SizedBox(height: 10),
                            Text('global_txt_37'.tr,style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Text('global_txt_38'.tr,style: TextStyle(fontSize: 14,color: Colors.grey)),
                          ],
                        ),
                      ),
                    ) : Center(child: Container(width: 50, height: 50, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3))),
                    SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
