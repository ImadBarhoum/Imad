import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/widgets/topwg.dart';
import '/config.dart';
import '/services/api_service.dart';

class AgencyPage extends StatefulWidget {
  const AgencyPage({super.key});

  @override
  State<AgencyPage> createState() => _AgencyPageState();
}

class _AgencyPageState extends State<AgencyPage> {
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;

  final id = (Get.arguments != null && Get.arguments.containsKey('id')) ? Get.arguments['id'] : '';
  late dynamic agency = {
    'id': 0,
    'name': '',
    'description': '',
    'phone': '',
    'state': '',
    'city': '',
    'address': '',
    'img': '',
    'cover': '',
    'rate': '',
    'reviews': 0,
  };
  late dynamic ads = [];

  Future<void> getAgency() async {
    setState(() {_isLoading = true;});
    var res = await apiService('/public/agency/get_agency', {'id':id});
    if(res != null && res['status'] == 1){
      await getData();
      setState(() {
        agency = res['data'];
        _isLoading = false;
      });
    }else{setState(() {_isLoading = false;});}
  }

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/public/properties/get_all', {'page':page,'agency_id':id});
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
    getAgency();
    _loadMoreController.addListener(() {if (_loadMoreController.offset == _loadMoreController.position.maxScrollExtent) {getData(skip:1);}});
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _loadMoreController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
            child: Column(
              children: [



                Stack(
                  children: [
                    !_isLoading && agency['id'] != 0 ? Container(
                      width: double.infinity,
                      height: 330,
                      child: agency['cover'] != ''
                          ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${agency['cover']}',fit: BoxFit.cover, placeholder: (context, url) => Container(), errorWidget: (context, url, error) => Image.asset('assets/imgs/user_bg.jpg'))
                          : Image.asset('assets/imgs/user_bg.jpg',fit: BoxFit.cover),
                    ) : Container(),
                    SafeArea(
                      child: !_isLoading && agency['id'] != 0 ? Column(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 45,bottom: 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(blurRadius: 15, color: Colors.grey, spreadRadius: 1)],
                                  ),
                                  child: Material(
                                    shape: const CircleBorder(),
                                    color: Colors.transparent,
                                    child: CircleAvatar(
                                      radius: 75,
                                      backgroundColor: Colors.white,
                                      child: agency['img'] != ''
                                          ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${agency['img']}', imageBuilder: (context, imageProvider) => CircleAvatar(radius: 75, backgroundImage: imageProvider,backgroundColor: Colors.white,), placeholder: (context, url) => Container(padding: EdgeInsets.all(20),child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 3)), errorWidget: (context, url, error) => Image.asset('assets/imgs/av.webp'))
                                          : const CircleAvatar(radius: 75, backgroundImage: AssetImage('assets/imgs/av.webp'),backgroundColor: Colors.white),
                                    ),
                                  ),
                                ),
                                agency['user_verify'] == 'yes' ? Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.verified_sharp,size: 38,color: Colors.blue),
                                      )
                                  ),
                                ):SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Column(
                              children: [
                                Text(agency['name'], style: const TextStyle(fontSize: 20,color: Colors.white)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("(${agency['reviews']}) ${agency['rate']}", style: TextStyle(fontSize: 16,color: Colors.white),maxLines: 1),
                                    SizedBox(width: 6),
                                    Icon(FontAwesomeIcons.solidStar,size: 16,color: Colors.amber),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ) : Container(),
                    ),
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3),),],
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.blueGrey.shade900),
                                onPressed: () {Get.back();},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),



                !_isLoading && agency['id'] != '' ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 0,left: 0,right: 0,bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      agency['description'] != '' ? Column(
                        children: [
                          Text("${agency['description']}",style: TextStyle(height: 1.7)),
                          SizedBox(height: 5),
                          Divider(height: 20),
                          SizedBox(height: 5),
                        ],
                      ): Center(),



                      ads.length != 0 ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //SizedBox(height: 10),
                          /*GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: MediaQuery.of(context).size.width < 640 ? 2:3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.52,
                            padding: EdgeInsets.all(5),
                            children: List.generate(products.length, (idx) {
                              return ProductCard(id: products[idx]['id'].toString(), name: products[idx]['name'], img: products[idx]['img'], price_regular: products[idx]['price_regular'], price_sale: products[idx]['price_sale'],currency: products[idx]['currency'], rate: products[idx]['rate'].toString(), reviews: products[idx]['reviews'].toString(), agency_name: products[idx]['agency_name']);
                            }),
                          ),*/
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
                      ):Column(
                        children: [
                          Center(child: Container(width: 220,padding: const EdgeInsets.all(15), child: Image.asset('assets/imgs/empty.png'))),
                          Text('ads_txt_1'.tr,style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ) :
                !_isLoading ? Container(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Image.asset('assets/imgs/empty.png'),
                      SizedBox(height: 10),
                      Text('global_txt_70'.tr,style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ) : Center(child: Container(width: 50, height: 50, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3)))






              ],
            )
        ),
      ),
    );
  }
}
