import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  late String auth = box.hasData('auth') ? box.read('auth') : '0';
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late dynamic data = {
    "views":"0",
    "reports":"0",
    "fav":"0",
    "ads":"0",
    "reviews":"0",
    "rate":"0.0",
  };

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/agency/agency/get_ads_page', {});
    if (res != null && res['status'] == 1) {
      setState(() {
        data = res['data'];
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
    return RefreshIndicator(
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
            auth == '1' ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        // 1. Top Cards Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3.5,
                          children: [
                            _buildAddAdCard(),
                          ],
                        ),
                        SizedBox(height: 15),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard("/agency/my_ads","global_txt_60".tr, data['ads'], Icons.insert_drive_file_outlined),
                            _buildStatCard("/fav","favorites".tr, data['fav'], Icons.favorite, iconColor: Colors.redAccent),
                            _buildStatCard("","total_views".tr, data['views'], Icons.public, iconColor: Colors.lightBlue),
                            _buildStatCard("","global_txt_58".tr, "${data['rate']} (${data['reviews']})", Icons.star, iconColor: Colors.orange),
                            //_buildStatCard("/reports","reports".tr, data['reports'], Icons.report, iconColor: Colors.redAccent),
                          ],
                        ),
                        SizedBox(height: 15),

                        // 2. Bottom Menu List
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildMenuItem("global_txt_56".tr,'/agency/profile'),
                              _buildDivider(),
                              _buildMenuItem("global_txt_57".tr,'/alerts'),
                              _buildDivider(),
                              _buildMenuItem("recent_view".tr,'/recent_view'),
                              //_buildDivider(),
                              //_buildMenuItem("test".tr,'/test'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ) : Center(
              child: Container(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Container(width: 250,child: Image.asset('assets/imgs/not_login.png')),
                    SizedBox(height: 10),
                    Text('global_txt_61'.tr,style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('global_txt_62'.tr,style: TextStyle(fontSize: 14,color: Colors.grey)),
                    TextButton(onPressed: (){Get.toNamed('/auth/login');}, child: Text('login'.tr,style: TextStyle(fontSize: 16,color: Colors.orange)))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper for the top 3 stat cards
Widget _buildStatCard(String route,String title, String value, IconData icon, {Color iconColor = Colors.black}) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
    ),
    child: InkWell(
      onTap: (){
        if(route != ""){
          Get.toNamed(route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[700])),
              Icon(icon, color: iconColor, size: 28),
            ],
          ),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    ),
  );
}

// Helper for the "Add Ad" card with the orange plus icon
Widget _buildAddAdCard() {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
    ),
    child: InkWell(
      onTap: (){
        Get.toNamed('/agency/add_ads');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, color: Colors.orange, size: 30),
          SizedBox(height: 8),
          Text("global_txt_63".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

// Helper for menu items
Widget _buildMenuItem(String title,String route) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
    onTap: () {
      if(route != ""){
        Get.toNamed(route);
      }
    },
  );
}

Widget _buildDivider() => Divider(height: 1, indent: 15, endIndent: 15, color: Colors.grey[200]);







