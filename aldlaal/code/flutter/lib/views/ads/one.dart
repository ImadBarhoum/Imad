import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';
import '/config.dart';

class AdsOnePage extends StatefulWidget {
  const AdsOnePage({super.key});

  @override
  State<AdsOnePage> createState() => _AdsOnePageState();
}

class _AdsOnePageState extends State<AdsOnePage> {
  late bool _isLoading = true;
  String uuid = box.hasData('uuid') ? box.read('uuid') : '';
  String user_id = box.hasData('user_id') ? box.read('user_id') : '';
  String MAP_URL = box.hasData('map_url') ? box.read('map_url') : 'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png';

  final id = (Get.arguments != null && Get.arguments.containsKey('id')) ? Get.arguments['id'] : Get.parameters['id'] ?? '0';
  late dynamic ads = {
    'id': '',
    'owner_id': '',
    'agency_id': '',
    'agency': '',
    'phone': '',
    'user_verify': '',
    'agency_reviews': '',
    'agency_rate': '',

    'title': '',
    'address': '',
    'description': '',
    'img': '',
    'video': '',
    'plan_img': '',
    'imgs': [],
    'price': '0',
    'state': '',
    'city': '',
    'bedrooms': '',
    'bathrooms': '',
    'garages': '',
    'type': '',
    'area_m2': '',
    'purpose': '',

    'is_owner': '',
    'property_nature': '',
    'floor': '',
    'area_unit': '',
    'building_age': '',
    'is_mortgaged': '',
    'property_status': '',
    'designated_for': '',
    'facade': '',
    'rent_duration': '',
    'payment_method': '',
    'main_features': [],
    'internal_features': [],
    'appliances': [],
    'extra_features': [],
    'nearby_places': [],

    'estate_status': '',
    'location': null,
    'is_furnished': '',
    'is_new': '',
    'is_fav': 0,
    'create_at':'',
  };
  late dynamic carousel = [];
  int _current = 0;
  late List<String> report_list = [
    'sold_ad',
    'duplicate_ad',
    'offensive_ad',
    'ad_in_wrong_section',
    'incorrect_images',
    'wrong_price',
    'fraud',
    'other',
  ];
  String report_select = "";
  TextEditingController report_note = TextEditingController();


  Future<void> getData() async {
    setState(() {_isLoading = true;});
    var res = await apiService('/public/properties/get_one', {'id':id});
    if(res != null && res['status'] == 1){
      setState(() {
        ads = res['data'];
        //carousel.add(ads['img']);
        carousel.addAll(ads['imgs']);
        _isLoading = false;
      });
      await apiService('/public/properties/add_history', {'uuid':uuid,'id':res['data']['id']});
    }else{setState(() {_isLoading = false;});}
  }


  void reportNow(){
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return SafeArea(
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 350),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('report'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                            IconButton(icon: Icon(FontAwesomeIcons.close,size: 28,color: Colors.blueGrey[700]), onPressed: () {Get.back();}),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text('report_choose'.tr),
                            items: report_list.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item!.toString().tr),
                              );
                            }).toList(),
                            onChanged: (value) {setState(() {report_select = value ?? '';});},
                            value: report_select.isNotEmpty ? report_select : null,
                            buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 8, right: 8)),
                            menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                            dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                            underline: SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: report_note,
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          decoration: InputDecoration(
                            label: Text("note".tr, style: TextStyle(color: Colors.blueGrey.shade600)),
                            hintText: "note".tr,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: const Color(0xFFF1F2F4),
                            counterText: "",
                          ),
                          inputFormatters: [LengthLimitingTextInputFormatter(150)],
                          onChanged: (v) => setState(() {}),
                        ),


                        Spacer(),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async{
                              if(report_select != ''){
                                var res = await apiService('/user/properties/report_now', {'id':id,'agency_id':ads['agency_id'],'type':report_select,'note':report_note.text});
                                if (res != null && res['status'] == 1) {
                                  getData();
                                  Get.back();
                                  Get.snackbar('success'.tr, 'settings_txt_32'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                }else{
                                  Get.back();
                                  Get.snackbar('sorry!'.tr, 'try_again'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else{
                                Get.snackbar('sorry!'.tr, 'global_txt_88'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                            child: Text('send'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

  }



  @override
  void initState() {
    super.initState();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0);
    var curr = box.hasData('currency') ? box.read("currency").toString() : 'SYP';
    var exchange = box.hasData('exchange') ? box.read("exchange") : '1';
    var echange_price = curr == 'USD' ? formatter.format(double.parse(ads['price'])/double.parse(exchange)) : formatter.format(double.parse(ads['price']));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBody: false,
      bottomNavigationBar: !_isLoading && ads['id'] != '' && user_id != ads['owner_id'] ? Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff1f3c5a),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xff1f3c5a)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async{
                    if(box.hasData('auth') && box.read('auth') == '1'){
                      Get.toNamed('/chat',arguments: {'id':id});
                    }else{
                      Get.snackbar('sorry!'.tr, 'settings_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                    }
                  },
                  icon: const Icon(Icons.chat_bubble, size: 18),
                  label: Text('chat'.tr,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1f3c5a),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                  ),
                  onPressed: () async{
                    if(ads['phone'] != "0"){
                      var url = 'tel:+${ads['phone']}';
                      if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));}
                    }
                  },
                  icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                  label: Text("call".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ) : null,
      appBar: AppBar(
        leadingWidth: 77,
        title: Image.asset('assets/logo_white.png',height: 50),
        centerTitle: true,
        backgroundColor: Color(0xff1f3c5a),
        elevation: 0,
        actions: [
          /*IconButton(
            icon: Icon(FontAwesomeIcons.solidCopy,size: 28,color: Colors.white),
            onPressed: () async{
              var urlToCopy = 'https://aldlaal.com/link/${id}';
              await Clipboard.setData(ClipboardData(text: urlToCopy));
              Get.snackbar('success'.tr, 'global_txt_40'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
            },
          ),
          IconButton(
            icon: Icon(ads['is_fav'] == 1 ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,size: 28,color: ads['is_fav'] == 1 ? Colors.redAccent : Colors.white),
            onPressed: () async{
              var res = await apiService('/user/properties/set_fav', {'id':id});
              if(res != null && res['status'] == 1){
                setState(() {
                  box.write('fav_refresh','1');
                  ads['is_fav'] = ads['is_fav'] == 1 ? 0:1;
                });
              }else{
                Get.snackbar('sorry!'.tr, 'ads_txt_8'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
              }
            },
          )*/
        ],
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.white),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {Get.back();} else {Get.offAllNamed('/home');}
          },
        ),
      ),
      body: SingleChildScrollView(
        child: !_isLoading && ads['id'] != '' ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Color(0xff1f3c5a),
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 6),
            ),


            Container(
              child: carousel.length <= 1 ? AspectRatio(
                aspectRatio: 1/1,
                child: ads['img'] != '' ? Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/lg/${ads['img']}',fit: BoxFit.cover,placeholder: (context, url) =>
                        Center(child: Container(width: 50, height: 50, child: const CircularProgressIndicator(color: Colors.black,)),
                        ), errorWidget: (context, url, error) => Container(padding: EdgeInsets.only(top: 40),child: Image.asset('assets/imgs/no_img.webp'))),
                    Center(child: Opacity(opacity: 0.4, child: Image.asset('assets/logo_white.png', width: 150, height: 150))),
                  ],
                ) : Container(padding: EdgeInsets.only(top: 40),child: Image.asset('assets/imgs/no_img.webp')),
              ) : Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: carousel.length,
                    itemBuilder: (context, index, realIdx) {
                      return AspectRatio(
                        aspectRatio: 1/1,
                        child: carousel[index] != ''
                            ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: '$API_URL/uploads/imgs/lg/${carousel[index]}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(color: Colors.black,),),
                              ),
                              errorWidget: (context, url, error) => Container(padding: const EdgeInsets.only(top: 40), child: Image.asset('assets/imgs/no_img.webp'),),
                            ),
                            Center(child: Opacity(opacity: 0.4, child: Image.asset('assets/logo_white.png', width: 150, height: 150))),
                          ],
                        )
                            : Container(padding: const EdgeInsets.only(top: 40), child: Image.asset('assets/imgs/no_img.webp'),),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: false,
                      aspectRatio: 1/1,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 5),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedSmoothIndicator(
                        activeIndex: _current,
                        count: carousel.length,
                        effect: const WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            SizedBox(height:5),
            // Titles
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(ads['title'], style: TextStyle(fontSize: 20),maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                      SizedBox(height: 5),
                      Row(
                        children: [

                          Text("$echange_price ${curr.tr}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines: 1),
                          Spacer(),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.triangleExclamation, size: 26, color: Colors.blueGrey.shade700),
                            onPressed: () {
                              reportNow();
                            },
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.shareFromSquare, size: 26, color: Color(0xff1f3c5a)),
                            onPressed: () {
                              var urlToShare = 'https://aldlaal.com/link/${id}';
                              Share.share(urlToShare);
                            },
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(ads['is_fav'] == 1 ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,size: 26,color: Colors.redAccent),
                            onPressed: () async{
                              var res = await apiService('/user/properties/set_fav', {'id':id});
                              if(res != null && res['status'] == 1){
                                setState(() {
                                  box.write('fav_refresh','1');
                                  ads['is_fav'] = ads['is_fav'] == 1 ? 0:1;
                                });
                              }else{
                                Get.snackbar('sorry!'.tr, 'ads_txt_8'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(ads['address'], style: TextStyle(fontSize: 14),maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                      SizedBox(height: ads['address'] != '' ? 5:0),


                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text('bedrooms'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Text(ads['bedrooms'].toString().tr,style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text('bathrooms'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 10),
                                Text(ads['bathrooms'].toString().tr,style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text('floor'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Text(ads['floor'].toString().tr,style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('global_txt_68'.tr),
                          Spacer(),
                          Text("${ads['create_at']}"),
                        ],
                      ),
                      SizedBox(height: 0),

                    ],
                  ),
                ),
              ),
            ),

            // Specs
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('state'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(FontAwesomeIcons.mountainCity,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['state'],style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('city'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(FontAwesomeIcons.city,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['city'],style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('type'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(FontAwesomeIcons.building,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['type'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('size'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(FontAwesomeIcons.layerGroup,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text("${ads['area_m2']} ${ads['area_unit'].toString().tr}",style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('building_age'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(FontAwesomeIcons.calendar,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['building_age'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('mortgaged'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.buildingColumns,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['is_mortgaged'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('property_status'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.buildingCircleExclamation,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['property_status'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('designated_for'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.buildingFlag,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['designated_for'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('facade'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.schoolFlag,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['facade'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('purpose'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.fileShield,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['purpose'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('property_nature'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.buildingShield,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['property_nature'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ads_txt_4'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(FontAwesomeIcons.couch,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['is_furnished'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('rent_duration'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.fileInvoiceDollar,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['rent_duration'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('payment_method'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.creditCard,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['payment_method'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('status'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a))),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(height: 5),
                                    Icon(FontAwesomeIcons.tag,color: Color(0xff1f3c5a),size: 18),
                                    SizedBox(width: 10),
                                    Text(ads['estate_status'].toString().tr,style: TextStyle(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),


            // Options
            ads['main_features'].length == 0 && ads['internal_features'].length == 0 && ads['appliances'].length == 0 && ads['extra_features'].length == 0 && ads['nearby_places'].length == 0 ? Container() : Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ads['main_features'].length == 0 ? Container() : _buildMultiChoiceGroup('main_features'.tr, ads['main_features'].cast<String>()),
                      ads['internal_features'].length == 0 ? Container() : _buildMultiChoiceGroup('internal_features'.tr, ads['internal_features'].cast<String>()),
                      ads['appliances'].length == 0 ? Container() : _buildMultiChoiceGroup('appliances'.tr, ads['appliances'].cast<String>()),
                      ads['extra_features'].length == 0 ? Container() : _buildMultiChoiceGroup('extra_features'.tr, ads['extra_features'].cast<String>()),
                      ads['nearby_places'].length == 0 ? Container() : _buildMultiChoiceGroup('nearby_places'.tr, ads['nearby_places'].cast<String>()),
                    ],
                  ),
                ),
              ),
            ),

            // Description
            ads['description'] != '' ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(FontAwesomeIcons.solidBookmark,color: Color(0xff1f3c5a)),
                          SizedBox(width: 5),
                          Text('description'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a),fontWeight: FontWeight.bold)),
                          Spacer(),
                        ],
                      ),
                      Divider(),
                      Html(data: ads['description']),
                    ],
                  ),
                ),
              ),
            ) : Container(),

            // Video
            ads['video'] != '' ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(FontAwesomeIcons.play,color: Color(0xff1f3c5a)),
                          SizedBox(width: 5),
                          Text('video'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a),fontWeight: FontWeight.bold)),
                          Spacer(),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      ads['video'] != '' ? Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.blueGrey.shade900),
                        child: VPlayer(videoUrl: '${API_URL}/uploads/videos/${ads['video']}'),
                      ) : Container()
                    ],
                  ),
                ),
              ),
            ) : Container(),

            // Plan
            ads['plan_img'] != '' ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(FontAwesomeIcons.layerGroup,color: Color(0xff1f3c5a)),
                          SizedBox(width: 5),
                          Text('ads_txt_6'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a),fontWeight: FontWeight.bold)),
                          Spacer(),
                        ],
                      ),
                      Divider(),
                      ads['plan_img'] != '' ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/lg/${ads['plan_img']}',fit: BoxFit.cover,placeholder: (context, url) =>
                      Center(child: Container(width: 50, height: 50, child: const CircularProgressIndicator(color: Colors.black,)),
                      ), errorWidget: (context, url, error) => Container(padding: EdgeInsets.only(top: 40),child: Image.asset('assets/imgs/no_img.webp'))) : Container(padding: EdgeInsets.only(top: 40),child: Image.asset('assets/imgs/no_img.webp')),
                    ],
                  ),
                ),
              ),
            ) : Container(),

            // Agency Profile
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(FontAwesomeIcons.user,color: Color(0xff1f3c5a)),
                          SizedBox(width: 5),
                          Text('global_txt_69'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a),fontWeight: FontWeight.bold)),
                          Spacer(),
                        ],
                      ),
                      Divider(),


                      Card(
                        color: Colors.white,
                        elevation: 3,
                        shadowColor: Colors.blueGrey.withOpacity(0.2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {Get.toNamed('/ads/agency',arguments: {'id':ads['agency_id']});},
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 98,
                                    child: AspectRatio(
                                      aspectRatio: 1/1,
                                      child: ClipRRect(
                                          child: ads['agency_img'] != '' ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/sm/${ads['agency_img']}', imageBuilder: (context, imageProvider) => CircleAvatar(radius: 75, backgroundImage: imageProvider,backgroundColor: Colors.white,), placeholder: (context, url) => Container(padding: EdgeInsets.all(20),child: const CircularProgressIndicator(color: Colors.orangeAccent,strokeWidth: 2.5,)), errorWidget: (context, url, error) => Image.asset('assets/imgs/av.webp')):Image.asset('assets/imgs/av.webp'),
                                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(10))
                                      ),
                                    ),
                                  ),
                                  ads['user_verify'] == 'yes' ? Positioned.fill(
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(Icons.verified_sharp,size: 24,color: Colors.blue),
                                        )
                                    ),
                                  ):Center(),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                  height: 98,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ads['agency'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      SizedBox(height: 4),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.solidStar,size: 20,color: Colors.orange,),SizedBox(width: 5),
                                          Flexible(child: Text('(${ads['agency_reviews']}) ${ads['agency_rate']}',style: TextStyle(fontSize: 14))),
                                          Spacer(),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    IconButton(onPressed: () async{
                                      if(ads['phone'] != "0"){
                                        var url = 'tel:+${ads['phone']}';
                                        if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));}
                                      }
                                    }, icon: Icon(FontAwesomeIcons.phone),color: Colors.blue,),
                                    IconButton(onPressed: !_isLoading && ads['id'] != '' && user_id != ads['owner_id'] ? (){
                                      if(box.hasData('auth') && box.read('auth') == '1'){
                                        Get.toNamed('/chat',arguments: {'id':id});
                                      }else{
                                        Get.snackbar('sorry!'.tr, 'settings_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                      }
                                    }:null, icon: Icon(FontAwesomeIcons.message),color: Color(0xff1f3c5a)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // Map
            ads['location'] != null ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(FontAwesomeIcons.map,color: Color(0xff1f3c5a)),
                          SizedBox(width: 5),
                          Text('ads_txt_7'.tr,style: TextStyle(fontSize: 14,color: Color(0xff1f3c5a),fontWeight: FontWeight.bold)),
                          Spacer(),
                        ],
                      ),
                      Divider(),
                      Container(
                        height: 300,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(ads['location']['lat'],ads['location']['lng']),
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                                urlTemplate: "${MAP_URL}",
                                userAgentPackageName: 'com.aldlaal.app',
                                additionalOptions: const {'User-Agent': 'com.aldlaal.app',}
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80,
                                  height: 80,
                                  point: LatLng(ads['location']['lat'],ads['location']['lng']),
                                  child: Icon(FontAwesomeIcons.locationDot, color: Colors.blueAccent, size: 50),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ):Container(),








          ],
        ) :
          !_isLoading ? Center(
          child: Container(
          padding: EdgeInsets.only(top: 80),
          child:Column(
            children: [
              Container(width: 250,child: Image.asset('assets/imgs/empty.png')),
              SizedBox(height: 10),
              Text('settings_txt_7'.tr,style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        ) : Center(child: Container(width: 75, height: 75, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3))),
      ),
    );
  }

  Widget _buildMultiChoiceGroup(String title, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade600, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0, runSpacing: 8.0,
            children: options.map((opt) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(opt.tr, style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade800)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}







