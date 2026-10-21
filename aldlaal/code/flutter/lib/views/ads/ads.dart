import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '/config.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  late int screen = 0;
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late bool finalPage = false;
  late int page = 1;
  final curr = box.hasData('currency') ? box.read('currency') : 'SYP';
  final exchange = box.hasData('exchange') ? box.read('exchange') : '1';
  late dynamic ads = [];
  final List<String> numberItems = ['studio', '1', '2', '3', '4', '5', '6+'];
  late String id = '';
  late String purpose = '';
  late String type = '';
  late String is_furnished = '';
  late String is_new = '';
  late String state = '';
  late String city = '';
  late String bedrooms = '';
  late String bathrooms = '';
  late String garages = '';
  late String date_filter = '';
  TextEditingController size_min = TextEditingController();
  TextEditingController size_max = TextEditingController();
  TextEditingController price_min = TextEditingController();
  TextEditingController price_max = TextEditingController();
  late dynamic states = [];
  late dynamic citys = [];
  late dynamic purposes = ['rent','sale'];
  late dynamic date_filter_list = ['all','last_7d','last_30d'];
  late dynamic types = ['apartment','house','building','villa','land','office','shop','warehouse','farm','restaurant','clinic','block'];
  late dynamic furnishes = ['furnished','unfurnished','fully furnished','fartially furnished'];
  late dynamic yesno = ['yes','no'];

  final TextEditingController _titleController = TextEditingController();
  int _notificationApp = 0;
  int _notificationEmail = 0;
  String MAP_URL = box.hasData('map_url') ? box.read('map_url') : 'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png';

  Future<void> getStates() async{
    var res = await apiService('/others/get_states', {});
    if(res != null && res['status'] == 1){
      setState(() {
        states = [{'id':'','name_ar':'الكل','name_en':'All'}, ...res['data']];
      });
    }
  }
  Future<void> getCitys() async{
    setState(() {city = '';});
    var res = await apiService('/others/get_citys', {'state': state});
    if(res != null && res['status'] == 1){
      setState(() {
        citys = [{'id':'','name_ar':'الكل','name_en':'All'}, ...res['data']];
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/public/properties/get_all', {
      'page':page,
      'purpose':purpose,
      'type': type,
      'search': _searchController.text,
      'is_furnished': is_furnished, 'is_new': is_new,
      'bedrooms': bedrooms, 'bathrooms': bathrooms, 'garages': garages,
      'city': city, 'state': state,
      'size_min': size_min.text, 'size_max': size_max.text,
      'price_min': price_min.text, 'price_max': price_max.text,
      'date_filter': date_filter,
    });
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 10) finalPage = true;
        page == 1 ? ads = res['data'] : ads.addAll(res['data']);
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }

  Future<void> getSearchFav() async {
    if(id != '' && box.hasData('auth') && box.read('auth') == '1'){
      var res = await apiService('/user/alerts/get_one', {'id':id});
      if (res != null && res['status'] == 1) {
        setState(() {
          purpose = res['data']['search_json']['purpose'].toString();
          type = res['data']['search_json']['type'].toString();
          bedrooms = res['data']['search_json']['bedrooms'].toString();
          bathrooms = res['data']['search_json']['bathrooms'].toString();
          garages = res['data']['search_json']['garages'].toString();
          size_min.text = res['data']['search_json']['size_min'].toString();
          size_max.text = res['data']['search_json']['size_max'].toString();
          price_min.text = res['data']['search_json']['price_min'].toString();
          price_max.text = res['data']['search_json']['price_max'].toString();
          state = res['data']['search_json']['state'].toString();
          city = res['data']['search_json']['city'].toString();
          is_furnished = res['data']['search_json']['is_furnished'].toString();
          is_new = res['data']['search_json']['is_new'].toString();
        });
        await getStates();
        await getCitys();
        apiService('/user/alerts/reset_count', {'id':id});
      }
    }else{
      purpose = (Get.arguments != null && Get.arguments.containsKey('purpose')) ? Get.arguments['purpose'] : '';
      type = (Get.arguments != null && Get.arguments.containsKey('type')) ? Get.arguments['type'] : '';
      bedrooms = (Get.arguments != null && Get.arguments.containsKey('bedrooms')) ? Get.arguments['bedrooms'] : '';
      bathrooms = (Get.arguments != null && Get.arguments.containsKey('bathrooms')) ? Get.arguments['bathrooms'] : '';
      garages = (Get.arguments != null && Get.arguments.containsKey('garages')) ? Get.arguments['garages'] : '';
      size_min.text = (Get.arguments != null && Get.arguments.containsKey('size_min')) ? Get.arguments['size_min'] : '';
      size_max.text = (Get.arguments != null && Get.arguments.containsKey('size_max')) ? Get.arguments['size_max'] : '';
      price_min.text = (Get.arguments != null && Get.arguments.containsKey('price_min')) ? Get.arguments['price_min'] : '';
      price_max.text = (Get.arguments != null && Get.arguments.containsKey('price_max')) ? Get.arguments['price_max'] : '';
      await getStates();
      state = (Get.arguments != null && Get.arguments.containsKey('state')) ? Get.arguments['state'] : '';
      await getCitys();
      city = (Get.arguments != null && Get.arguments.containsKey('city')) ? Get.arguments['city'] : '';
    }
  }

  void _resetFilters() {
    setState(() {
      size_min.clear();
      size_max.clear();
      price_min.clear();
      price_max.clear();
      _searchController.clear();
      type = '';
      bedrooms = '';
      bathrooms = '';
      garages = '';
      date_filter = '';
    });
  }

  void initFields() async{
    setState(() {id = (Get.arguments != null && Get.arguments.containsKey('id')) ? Get.arguments['id'] : '';});
    await getSearchFav();

    LatLng location;
    location = LatLng(33.461591,36.2873869);
    setState(() {currentLocation = location;});

    getData();
    getMap();
  }

  // MAP
  final MapController mapController = MapController();
  LatLng? currentLocation;
  late dynamic ads_map = [];
  List<Marker> markers=[];
  List<Marker> marker=[];

  Future<void> getMap() async{
    setState(() {_isLoading = true;});
    var res = await apiService('/public/properties/get_map', {
      'page':page,
      'purpose':purpose,
      'type': type,
      'search': _searchController.text,
      'is_furnished': is_furnished, 'is_new': is_new,
      'bedrooms': bedrooms, 'bathrooms': bathrooms, 'garages': garages,
      'city': city, 'state': state,
      'size_min': size_min.text, 'size_max': size_max.text,
      'price_min': price_min.text, 'price_max': price_max.text,
      'date_filter': date_filter,
    });
    if(res != null && res['status'] == 1){
      ads_map = res['data'];
      markers.clear();
      for(var i=0;i<res['data'].length;i++){
        _addMarker(LatLng(ads_map[i]['location']['lat'],ads_map[i]['location']['lng']),ads_map[i]['img'],i);
      }
    }
    setState(() {_isLoading = false;});
  }

  void showAds(int idx){
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AdsMapCard(id: ads_map[idx]['id'].toString(),owner_id: ads_map[idx]['owner_id'].toString(),phone: ads_map[idx]['phone'].toString(), agency: ads_map[idx]['agency'], title: ads_map[idx]['title'], price: ads_map[idx]['price'], curr: ads_map[idx]['curr'], area_m2: ads_map[idx]['area_m2'], bedrooms: ads_map[idx]['bedrooms'].toString(), bathrooms: ads_map[idx]['bathrooms'].toString(), garages: ads_map[idx]['garages'].toString(), img: ads_map[idx]['img'], imgs: ads_map[idx]['imgs'], location: "${ads_map[idx]['state']}, ${ads_map[idx]['city']}", date: ads_map[idx]['create_at'], is_fav: ads_map[idx]['is_fav'],onRefresh: getData)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addMarker(LatLng position,String img,int idx) {
    markers.add(
        Marker(
          width: 75,
          height: 75,
          point: position,
          child: GestureDetector(
            onTap: (){showAds(idx);},
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.location_pin, color: Colors.blueGrey, size: 75),
                Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,),
                    child: ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: img != ''
                            ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/sm/${img}', fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: Container(width: 25, height: 25, child: const CircularProgressIndicator(color: Colors.black))),
                            errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp', fit: BoxFit.cover)) : Image.asset('assets/imgs/no_img.webp', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void _addMarkerGPS(LatLng position) {
    marker = [
      Marker(
        width: 80,
        height: 80,
        point: position,
        child: Icon(FontAwesomeIcons.locationDot, color: Colors.blueAccent, size: 50),
      ),
    ];
  }

  Future<void> _getCurrentLocation() async{
    setState(() { _isLoading = true; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => _isLoading = false);
        print("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          setState(() => _isLoading = false);
          print("Location permission denied.");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ).timeout(Duration(seconds: 15), onTimeout: () {
        setState(() => _isLoading = false);
        print("Location timeout.");
        throw TimeoutException("Location timeout.");
      });

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _addMarkerGPS(currentLocation!);
        mapController.move(currentLocation!, 13);
        _isLoading = false;
      });
    } catch (e) {
      print("Error with geolocator: $e");
      setState(() {
        _isLoading = false;
        currentLocation = null;
      });
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('alert'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'title'.tr, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF1F2F4)),
                    ),
                    const SizedBox(height: 20),
                    Text('notifications'.tr, style: TextStyle(fontWeight: FontWeight.bold),),
                    CheckboxListTile(
                      title: Text('notification'.tr),
                      value: _notificationApp == 1,
                      onChanged: (bool? newValue) {setState(() {_notificationApp = newValue! ? 1 : 0;});},
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text('email'.tr),
                      value: _notificationEmail == 1,
                      onChanged: (bool? newValue) {setState(() {_notificationEmail = newValue! ? 1 : 0;});},
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('close'.tr,style: TextStyle(color: Colors.black)),
                  onPressed: () {Navigator.of(context).pop();},
                ),
                ElevatedButton(
                  child: Text('save'.tr,style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xff1f3c5a),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),)
                  ),
                  onPressed: () async{
                    var res = await apiService('/user/alerts/add', {
                      'title':_titleController.text,
                      'search_json': {
                        'purpose': purpose,
                        'type': type,
                        'is_furnished': is_furnished,
                        'is_new': is_new,
                        'state': state,
                        'city': city,
                        'bedrooms': bedrooms,
                        'bathrooms': bathrooms,
                        'garages': garages,
                        'size_min': size_min.text,
                        'size_max': size_max.text,
                        'price_min': price_min.text,
                        'price_max': price_max.text,
                      },
                      'notification_app': _notificationApp,
                      'notification_email': _notificationEmail,
                    });
                    if (res != null && res['status'] == 1) {
                      Get.snackbar('success'.tr, 'settings_txt_18'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    initFields();
    super.initState();
    _loadMoreController.addListener(() {if (_loadMoreController.offset == _loadMoreController.position.maxScrollExtent) {getData(skip: 1);}});
  }

  @override
  void dispose() {
    _loadMoreController.dispose();
    _searchController.dispose(); // تنظيف المتحكم
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 77,
        title: Image.asset('assets/logo_white.png',height: 50),
        centerTitle: true,
        backgroundColor: Color(0xff1f3c5a),
        elevation: 0,
        actions: [
          screen == 1 ? IconButton(
            icon: Icon(FontAwesomeIcons.locationCrosshairs,size: 28,color: Colors.yellow),
            onPressed: _isLoading ? (){} : (){_getCurrentLocation();},
          ):Container(),
          SizedBox(width: 3),
        ],
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.white),
          onPressed: () {Get.back();},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(screen == 1){
            setState(() {screen = 0;});
          }else{
            setState(() {screen = 1;});
          }
        },
        child: Icon(screen == 1 ? FontAwesomeIcons.listUl : FontAwesomeIcons.mapLocation,color: Colors.white),
        backgroundColor: Color(0xff1f3c5a),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Color(0xff1f3c5a),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) { getData(skip: 0); getMap(); },
                    decoration: InputDecoration(
                      hintText: 'search'.tr,
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    getData(skip: 0);
                    getMap();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.white, size: 20),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(FontAwesomeIcons.filter, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: types.length,
              itemBuilder: (context, index) {
                bool isSelected = type == types[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      type = isSelected ? '' : types[index];
                    });
                    getData(skip: 0);
                    getMap();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: isSelected ? Color(0xff1f3c5a) : Color(0xFFF1F2F4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Color(0xff1f3c5a) : Colors.transparent,
                        )
                    ),
                    child: Text(
                      types[index].toString().tr,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: screen == 1 ? FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentLocation ?? LatLng(33.461591,36.2873869),
                initialZoom: 10,
              ),
              children: [
                TileLayer(urlTemplate: "${MAP_URL}",userAgentPackageName: 'com.aldlaal.app'),
                MarkerLayer(markers: markers),
                MarkerLayer(markers: marker),
              ],
            ) : RefreshIndicator(
              color: Color(0xff1f3c5a),
              backgroundColor: Colors.white,
              onRefresh: getData,
              child: SingleChildScrollView(
                controller: _loadMoreController,
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
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
                                ]
                            ) :
                            !_isLoading && ads.length == 0 ? Center(
                              child: Container(
                                padding: EdgeInsets.only(top: 80),
                                child:Column(
                                  children: [
                                    Container(width: 250,child: Image.asset('assets/imgs/empty.png')),
                                    SizedBox(height: 10),
                                    Text('ads_txt_1'.tr,style: TextStyle(fontSize: 18)),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ) : Center(child: Container(width: 75, height: 75, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3))),
                            SizedBox(height: 20),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Text('filters'.tr, style: Theme.of(context).textTheme.headlineSmall),
                      Spacer(),
                      box.hasData('auth') && box.read('auth') == '1' ? ElevatedButton(
                          onPressed: () async{showAlertDialog();},
                          child: Icon(FontAwesomeIcons.solidBell,color: Colors.white),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Color(0xff1f3c5a),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )
                          )
                      ):Container()
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('purpose'.tr),
                      items: purposes.isNotEmpty ? [
                        for (var item in purposes)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          purpose = value ?? '';
                        });},
                      value: purpose.isNotEmpty && purposes.any((item) => item.toString() == purpose) ? purpose : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('type'.tr),
                      items: types.isNotEmpty ? [
                        for (var item in types)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          type = value ?? '';
                        });},
                      value: type.isNotEmpty && types.any((item) => item.toString() == type) ? type : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('is_furnished'.tr),
                      items: furnishes.isNotEmpty ? [
                        for (var item in furnishes)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          is_furnished = value ?? '';
                        });},
                      value: is_furnished.isNotEmpty && furnishes.any((item) => item.toString() == is_furnished) ? is_furnished : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  /*Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('is_new'.tr),
                      items: yesno.isNotEmpty ? [
                        for (var item in yesno)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          is_new = value ?? '';
                        });},
                      value: is_new.isNotEmpty && yesno.any((item) => item.toString() == is_new) ? is_new : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),*/
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('state'.tr),
                      items: states.isNotEmpty ? [
                        for (var item in states)
                          DropdownMenuItem<String>(value: item['name_ar'].toString(), child: Text(item['name_ar'].toString() ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {state = value ?? '';});
                        if(value == "الكل"){setState(() {state = '';});}
                        getCitys();
                      },
                      value: state.isNotEmpty && states.any((item) => item['name_ar'].toString() == state) ? state : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('city'.tr),
                      items: citys.isNotEmpty ? [
                        for (var item in citys)
                          DropdownMenuItem<String>(value: item['name_ar'].toString(), child: Text(item['name_ar'].toString() ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {city = value ?? '';});
                        if(value == "الكل"){setState(() {city = '';});}
                      },
                      value: city.isNotEmpty && citys.any((item) => item['name_ar'].toString() == city) ? city : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const Divider(height: 30),

                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('bedrooms'.tr),
                      items: numberItems.isNotEmpty ? [
                        for (var item in numberItems)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          bedrooms = value ?? '';
                        });},
                      value: bedrooms.isNotEmpty && numberItems.any((item) => item.toString() == bedrooms) ? bedrooms : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                      iconStyleData: const IconStyleData(icon: Icon(FontAwesomeIcons.bed, size: 20)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('bathrooms'.tr),
                      items: numberItems.isNotEmpty ? [
                        for (var item in numberItems)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          bathrooms = value ?? '';
                        });},
                      value: bathrooms.isNotEmpty && numberItems.any((item) => item.toString() == bathrooms) ? bathrooms : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                      iconStyleData: const IconStyleData(icon: Icon(FontAwesomeIcons.bath, size: 20)),
                    ),
                  ),
                  /*const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('garages'.tr),
                      items: numberItems.isNotEmpty ? [
                        for (var item in numberItems)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          garages = value ?? '';
                        });},
                      value: garages.isNotEmpty && numberItems.any((item) => item.toString() == garages) ? garages : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                      iconStyleData: const IconStyleData(icon: Icon(FontAwesomeIcons.car, size: 20)),
                    ),
                  ),*/
                  const Divider(height: 30),
                  Text('size'.tr),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(
                        controller: size_min,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(labelText: 'min'.tr, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF1F2F4)),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(
                        controller: size_max,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(labelText: 'max'.tr, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF1F2F4)),
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('price'.tr),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(
                        controller: price_min,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(labelText: 'min'.tr, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF1F2F4)),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(
                        controller: price_max,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(labelText: 'max'.tr, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF1F2F4)),
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text('date_filter'.tr),
                      items: date_filter_list.isNotEmpty ? [
                        for (var item in date_filter_list)
                          DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                      ] : [],
                      onChanged: (value) {
                        setState(() {
                          date_filter = value ?? '';
                        });},
                      value: date_filter.isNotEmpty && date_filter_list.any((item) => item.toString() == date_filter) ? date_filter : null,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                      dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                      underline: SizedBox.shrink(),
                    ),
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(
                          onPressed: _resetFilters,
                          child: Text('reset'.tr,style: TextStyle(color: Colors.black),),
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )
                      ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: ElevatedButton(
                        onPressed: () async{
                          getMap();
                          await getData(skip: 0);
                          if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('apply'.tr,style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color(0xff1f3c5a),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}