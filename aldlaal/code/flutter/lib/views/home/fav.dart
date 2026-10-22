import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late dynamic ads = [];

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/user/properties/get_fav', {'page':page});
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 12) finalPage = true;
        page == 1 ? ads = res['data'] : ads.addAll(res['data']);
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
        title: Text('favorites'.tr),
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
                    !_isLoading && ads.length != 0 ?
                    Column(
                      children: [
                        for(var i=0;i<ads.length;i++)
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              child: AdsCard(id: ads[i]['id'].toString(),owner_id: ads[i]['owner_id'].toString(),phone: ads[i]['phone'].toString(), agency: ads[i]['agency'], title: ads[i]['title'], price: ads[i]['price'], curr: ads[i]['curr'], area_m2: ads[i]['area_m2'], bedrooms: ads[i]['bedrooms'].toString(), bathrooms: ads[i]['bathrooms'].toString(), garages: ads[i]['garages'].toString(), img: ads[i]['img'], imgs: ads[i]['imgs'], location: "${ads[i]['state']}, ${ads[i]['city']}", date: ads[i]['create_at'], is_fav: ads[i]['is_fav'],onRefresh: getData)
                          ),
                        _isLoadMore ? Container(margin: EdgeInsets.symmetric(vertical: 30), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3)) : Container(),
                      ],
                    ) :
                    !_isLoading && ads.length == 0 ? Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Container(width: 250,child: Image.asset('assets/imgs/no_fav.webp')),
                            SizedBox(height: 10),
                            Text('home_txt_1'.tr,style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Text('home_txt_2'.tr,style: TextStyle(fontSize: 14,color: Colors.grey)),
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
