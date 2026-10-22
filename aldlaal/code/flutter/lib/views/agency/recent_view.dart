import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';

class RecentViewPage extends StatefulWidget {
  const RecentViewPage({super.key});

  @override
  State<RecentViewPage> createState() => _RecentViewPageState();
}

class _RecentViewPageState extends State<RecentViewPage> {
  String uuid = box.hasData('uuid') ? box.read('uuid') : '';
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late dynamic history = [];

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/public/properties/get_history', {'uuid':uuid});
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 24) finalPage = true;
        page == 1 ? history = res['data'] : history.addAll(res['data']);
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
        title: Text('recent_view'.tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blueGrey.withOpacity(0.2),
        elevation: 8,
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.blueGrey.shade900),
          onPressed: () {Get.back();},
        ),
        actions: [
          TextButton(onPressed: () async{
            var res = await apiService('/public/properties/clear_history', {'uuid':uuid});
            if(res != null && res['status'] == 1){
              Get.snackbar('success'.tr, 'settings_txt_23'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
              getData();
            }
          }, child: Text('clear'.tr))
        ],
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
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    !_isLoading && history.length != 0 ?
                    Column(
                      children: [
                        for(var i=0;i<history.length;i++)
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              child: AdsCard(id: history[i]['id'].toString(),owner_id: history[i]['owner_id'].toString(),phone: history[i]['phone'].toString(), agency: history[i]['agency'], title: history[i]['title'], price: history[i]['price'], curr: history[i]['curr'], area_m2: history[i]['area_m2'], bedrooms: history[i]['bedrooms'].toString(), bathrooms: history[i]['bathrooms'].toString(), garages: history[i]['garages'].toString(), img: history[i]['img'], imgs: history[i]['imgs'], location: "${history[i]['state']}, ${history[i]['city']}", date: history[i]['create_at'], is_fav: history[i]['is_fav'],onRefresh: getData)
                          ),
                        _isLoadMore ? Container(margin: EdgeInsets.symmetric(vertical: 30), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3)) : Container(),
                      ]
                    ) :
                    !_isLoading && history.length == 0 ? Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Container(width: 250,child: Image.asset('assets/imgs/empty.png')),
                            SizedBox(height: 10),
                            Text('home_txt_13'.tr,style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Text('home_txt_14'.tr,style: TextStyle(fontSize: 14,color: Colors.grey)),
                          ],
                        ),
                      ),
                    ) : Center(child: Container(width: 50, height: 50, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3))),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
