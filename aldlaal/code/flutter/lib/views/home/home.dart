import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  String uuid = box.hasData('uuid') ? box.read('uuid') : '';
  late dynamic home = {
    'sliders' : [],
  };
  TextEditingController search = TextEditingController();
  late String? filterSelect = '';
  late dynamic filter = [
    {'sort':'price','text':'product_txt_1'},
    {'sort':'order','text':'product_txt_2'},
    {'sort':'rate','text':'product_txt_3'},
    {'sort':'new','text':'product_txt_4'},
  ];
  final List<Map<String, String>> types = [
    {'id': 'apartment', 'name': 'apartment'},
    {'id': 'house', 'name': 'house'},
    {'id': 'building', 'name': 'building'},
    {'id': 'villa', 'name': 'villa'},
    {'id': 'land', 'name': 'land'},
    {'id': 'office', 'name': 'office'},
    {'id': 'shop', 'name': 'shop'},
    {'id': 'warehouse', 'name': 'warehouse'},
    {'id': 'farm', 'name': 'farm'},
    {'id': 'restaurant', 'name': 'restaurant'},
    {'id': 'clinic', 'name': 'clinic'},
    {'id': 'block', 'name': 'block'},
  ];
  late dynamic ads = [];

  Future<void> getHome() async {
    setState(() {_isLoading = true;});
    var res = await apiService('/public/home/get_home', {});
    if(res != null && res['status'] == 1){
      setState(() {
        home = res['data'];
        _isLoading = false;
      });
    }else{setState(() {_isLoading = false;});}
  }

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/public/properties/get_all', {'page':page});
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 10) finalPage = true;
        page == 1 ? ads = res['data'] : ads.addAll(res['data']);
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }



  @override
  void initState() {
    super.initState();
    getHome();
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
    final itemWidth = MediaQuery.of(context).size.width;
    double ratio;
    if(itemWidth <= 400){ratio = 0.52;} else {ratio = 0.6;}
    return RefreshIndicator(
      color: Color(0xff1f3c5a),
      backgroundColor: Colors.white,
      onRefresh: getData,
      child: SingleChildScrollView(
          controller: _loadMoreController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: [

                // Main 2 Buttons
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                  decoration: BoxDecoration(
                    color: Color(0xff1f3c5a),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(child: Text('home_txt_5'.tr,style: TextStyle(color: Colors.white,fontSize: 17))),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/ads/ads',arguments: {'purpose':'rent'});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('home_txt_6'.tr,style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 18,fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/ads/ads',arguments: {'purpose':'sale'});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('home_txt_7'.tr,style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 18,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),

                // Alerts
                /*
                box.hasData('auth') && box.read('auth') == '1' ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                          child: Column(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: (){
                                  Get.toNamed('/alerts');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(FontAwesomeIcons.solidBell,size: 23),
                                      SizedBox(width: 10),
                                      Text('home_txt_9'.tr,style: TextStyle(fontSize: 15),),
                                      Spacer(),
                                      Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleRight : FontAwesomeIcons.angleLeft,size: 23),
                                      SizedBox(width: 10)
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          )
                      )
                  ),
                ):Container(),
                */

                // History
                /*
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                  child: Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text('home_txt_8'.tr),
                              Spacer(),
                              TextButton(onPressed: () async{
                                var res = await apiService('/public/properties/clear_history', {'uuid':uuid});
                                if(res != null && res['status'] == 1){
                                  Get.snackbar('success'.tr, 'settings_txt_23'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                  getHistory();
                                }
                              }, child: Text('clear'.tr))
                            ],
                          ),

                          history.length != 0 ? Container(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: history.length,
                            itemBuilder: (context, idx) {
                              return Container(
                                width: 150,
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                child: AdsCardSlider(id: history[idx]['id'].toString(), agency: history[idx]['agency'], title: history[idx]['title'], price: history[idx]['price'], area_m2: history[idx]['area_m2'], bedrooms: history[idx]['bedrooms'].toString(), bathrooms: history[idx]['bathrooms'].toString(), garages: history[idx]['garages'].toString(), img: history[idx]['img']),
                              );
                            },
                          ),
                        ):Container(width: 200, child: Image.asset('assets/imgs/empty.png')),

                        ],
                      )
                    )
                  ),
                ),
                */


                SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Get.toNamed('/ads/ads',arguments: {'type':types[index]['id']});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 40,child: Image.asset('assets/imgs/types/${types[index]['name']}.png')),
                            SizedBox(height: 5),
                            Text(types[index]['name']!.tr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                //SizedBox(height: 10),
                // Sliders
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                  child: Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      child: SliderWidget(carousel: home['sliders'],aspectRatio: 16/9,box: true),
                  ),
                ),


                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  //childAspectRatio: 0.52,
                  childAspectRatio: ratio,
                  padding: EdgeInsets.all(10),
                  children: List.generate(ads.length, (i) {
                    return AdsCardSmall(id: ads[i]['id'].toString(),owner_id: ads[i]['owner_id'].toString(),phone: ads[i]['phone'].toString(), agency: ads[i]['agency'], title: ads[i]['title'], price: ads[i]['price'], curr: ads[i]['curr'], area_m2: ads[i]['area_m2'], bedrooms: ads[i]['bedrooms'].toString(), bathrooms: ads[i]['bathrooms'].toString(), garages: ads[i]['garages'].toString(), img: ads[i]['img'], imgs: ads[i]['imgs'], location: "${ads[i]['state']}, ${ads[i]['city']}", date: ads[i]['create_at'], is_fav: ads[i]['is_fav'],onRefresh: getData);
                  }),
                )


              ],
            ),
          )
      ),
    );
  }
}
