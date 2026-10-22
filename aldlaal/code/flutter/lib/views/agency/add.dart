import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '/widgets/topwg.dart';
import '/services/api_service.dart';
import '/config.dart';
import '/services/img_saver.dart';
import '/services/video_saver.dart';

class AddAdsPage extends StatefulWidget {
  @override
  _AddAdsPageState createState() => _AddAdsPageState();
}

class _AddAdsPageState extends State<AddAdsPage> {
  final id = (Get.arguments != null && Get.arguments.containsKey('id')) ? Get.arguments['id'] : '';
  // ==========================================
  // 1. المتغيرات
  // ==========================================
  int currentStep = 1;
  late bool _isLoading = false;
  String estate_status  = 'available';
  String status  = 'active';
  late dynamic estate_status_list  = ['available', 'sold', 'rented'];
  late dynamic status_list  = ['active', 'inactive'];

  // الجزء الأول:
  String? is_owner;
  String? purpose;
  String? type;
  String? property_nature;

  // الجزء الثاني:
  String? bedrooms;
  String? bathrooms;
  String? floor;
  TextEditingController area_m2  = TextEditingController();
  String area_unit  = 'sqm';
  String? building_age;
  String? is_furnished;
  String? is_mortgaged;
  String? property_status;
  String? designated_for;
  String? facade;
  String? rent_duration;

  // الجزء الثالث (الجديد - الموقع والخريطة):
  String state = '';
  String city = '';
  TextEditingController address = TextEditingController();
  List<dynamic> states = [];
  List<dynamic> citys = [];

  // متغيرات الخريطة
  double lat = 33.461591;
  double lng = 36.2873869;
  final MapController mapController = MapController();
  String MAP_URL = box.hasData('map_url') ? box.read('map_url') : 'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png';
  bool _isLoadingLocation = false;

  // الجزء الرابع:
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  String curr = 'SYP';
  String? payment_method;
  Set<String> main_features = {};
  Set<String> internal_features = {};
  Set<String> appliances = {};
  Set<String> extra_features = {};
  Set<String> nearby_places = {};

  // الجزء الخامس:
  String video = '';
  List<String> uploadedImages = [];
  int mainImageIndex = 0;
  TextEditingController videoUrlController = TextEditingController();

  Future<void> getStates() async {
    var res = await apiService('/others/get_states', {});
    if(res != null && res['status'] == 1){
      setState(() {states = res['data'];});
    }
  }

  Future<void> getCitys() async {
    var res = await apiService('/others/get_citys', {'state': state});
    if(res != null && res['status'] == 1){
      setState(() {citys = res['data'];});
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() { _isLoadingLocation = true; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => _isLoadingLocation = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ).timeout(Duration(seconds: 15));

      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        mapController.move(LatLng(lat, lng), 14);
        _isLoadingLocation = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          mapController.move(LatLng(lat, lng), 14);
        }
      });
    } catch (e) {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> fetchData() async {
    await getStates();
    if(id != ''){
      var res = await apiService('/agency/properties/get_one', {'id':id});
      if(res != null && res['status'] == 1){
        setState(() {
          estate_status = res['data']['estate_status'];
          status = res['data']['status'];
          is_owner = res['data']['is_owner'];
          purpose = res['data']['purpose'];
          type = res['data']['type'];
          property_nature = res['data']['property_nature'];
          bedrooms = res['data']['bedrooms'].toString();
          bathrooms = res['data']['bathrooms'].toString();
          floor = res['data']['floor'].toString();
          area_m2.text = res['data']['area_m2'].toString();
          area_unit = res['data']['area_unit'];
          building_age = res['data']['building_age'];
          is_furnished = res['data']['is_furnished'];
          is_mortgaged = res['data']['is_mortgaged'];
          property_status = res['data']['property_status'];
          designated_for = res['data']['designated_for'];
          facade = res['data']['facade'];
          rent_duration = res['data']['rent_duration'];
          state = res['data']['state'] ?? '';
          city = res['data']['city'] ?? '';
          address.text = res['data']['address'] ?? '';

          if(res['data']['location'] != null){
            lat = res['data']['location']['lat'] ?? 33.461591;
            lng = res['data']['location']['lng'] ?? 36.2873869;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {mapController.move(LatLng(lat, lng), 14);}
            });
          }

          video = res['data']['video'];
          title.text = res['data']['title'];
          description.text = res['data']['description'];
          price.text = res['data']['price'].toString();
          curr = res['data']['curr'].toString();
          payment_method = res['data']['payment_method'];
          main_features = res['data']['main_features'].cast<String>().toSet();
          internal_features = res['data']['internal_features'].cast<String>().toSet();
          appliances = res['data']['appliances'].cast<String>().toSet();
          extra_features = res['data']['extra_features'].cast<String>().toSet();
          nearby_places = res['data']['nearby_places'].cast<String>().toSet();
          uploadedImages = res['data']['imgs'].cast<String>();
        });
        if(state.isNotEmpty) {
          getCitys();
        }
        currentStep = 6;
      }
    }
  }

  Future<void> saveData() async {
    var action = (id == '') ? "add" : "edit";
    var res = await apiService('/agency/properties/'+action, {
      'id':id,
      'state':state,
      'city':city,
      'address':address.text,
      'location':{'lat':lat,'lng':lng},
      'lat': lat.toString(),
      'lng': lng.toString(),
      'title':title.text,
      'description':description.text,
      'purpose':purpose,
      'type':type,
      'price':price.text,
      'curr':curr,
      'bedrooms':bedrooms,
      'bathrooms':bathrooms,
      'area_m2':area_m2.text,
      'is_owner':is_owner,
      'property_nature':property_nature,
      'floor':floor,
      'area_unit':area_unit,
      'building_age':building_age,
      'is_furnished':is_furnished,
      'is_mortgaged':is_mortgaged,
      'property_status':property_status,
      'designated_for':designated_for,
      'facade':facade,
      'rent_duration':rent_duration,
      'payment_method':payment_method,
      'main_features':jsonEncode(main_features.toList()),
      'internal_features':jsonEncode(internal_features.toList()),
      'appliances':jsonEncode(appliances.toList()),
      'extra_features':jsonEncode(extra_features.toList()),
      'nearby_places':jsonEncode(nearby_places.toList()),
      'video':video,
      'img':uploadedImages[mainImageIndex],
      'imgs':uploadedImages,
      'estate_status':estate_status,
      'status':status,
    });
    if(res != null && res['status'] == 1){
      Get.back();
      Get.snackbar('success'.tr, id == '' ? 'global_txt_65'.tr : 'global_txt_66'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
    }
  }

  // ==========================================
  // 2. التحقق من صحة الخطوات (Validation)
  // ==========================================
  bool get isStep1Valid => is_owner != null && purpose != null && type != null && property_nature != null;

  bool get isStep2Valid {
    if (purpose == 'rent' && rent_duration == null) return false;
    if (area_m2 .text.isEmpty) return false;

    if (['apartment', 'house', 'villa'].contains(type)) {
      return bedrooms != null && bathrooms != null && floor != null && building_age != null && is_furnished != null && is_mortgaged != null;
    } else if (['office', 'shop', 'warehouse', 'restaurant', 'clinic'].contains(type)) {
      return floor != null && property_status != null && is_furnished != null && is_mortgaged != null;
    } else if (['land', 'farm','block'].contains(type)) {
      return designated_for != null && facade != null;
    }
    return true;
  }

  bool get isStep3Valid => state.isNotEmpty && city.isNotEmpty;

  bool get isStep4Valid => title.text.isNotEmpty && description.text.isNotEmpty && price.text.isNotEmpty && payment_method != null;

  bool get isStep5Valid => uploadedImages.isNotEmpty;

  bool _isCurrentStepValid() {
    if (currentStep == 1) return isStep1Valid;
    if (currentStep == 2) return isStep2Valid;
    if (currentStep == 3) return isStep3Valid;
    if (currentStep == 4) return isStep4Valid;
    if (currentStep == 5) return isStep5Valid;
    return true;
  }

  // ==========================================
  // 3. العمليات
  // ==========================================
  void nextStep() {
    if (currentStep < 6){
      setState(() => currentStep++);
      _scrollToTop();
    }
  }

  void prevStep() {
    if (currentStep > 1){
      setState(() => currentStep--);
      _scrollToTop();
    }
  }

  void editStep(int step) {
    _scrollToTop();
    setState(() => currentStep = step);
  }

  Future<void> pickAndUploadImage() async {
    if (uploadedImages.length >= 20) {
      Get.snackbar('warning'.tr, 'max_images_20'.tr, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    var imgName = await ImageSaver().Save();
    if (imgName != null && imgName.isNotEmpty) {
      setState(() {
        uploadedImages.add(imgName);
      });
    }
  }

  void _submit() {
    saveData();
    print("Publishing Ad...");
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {_scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn,);}

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ==========================================
  // 4. بناء الواجهة
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('add_real_estate_ad'.tr, style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blueGrey.withOpacity(0.1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight, size: 28, color: Colors.blueGrey.shade900),
          onPressed: () { Get.back(); },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (currentStep == 1) _buildStep1(),
                  if (currentStep == 2) _buildStep2(),
                  if (currentStep == 3) _buildStep3(), // الخطوة الجديدة
                  if (currentStep == 4) _buildStep4(),
                  if (currentStep == 5) _buildStep5(),
                  if (currentStep == 6) _buildStep6(), // الملخص
                ],
              ),
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: Row(
        children: [
          if (currentStep > 1)
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: prevStep,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('prev'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
              ),
            ),
          if (currentStep > 1) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isCurrentStepValid() ? (currentStep == 6 ? _submit : nextStep) : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff1f3c5a),
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                  currentStep == 6 ? 'publish'.tr : 'next'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isCurrentStepValid() ? Colors.white : Colors.grey.shade500)
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === الخطوات ===

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardsGroup('are_you'.tr, ['owner', 'broker'], is_owner, (val) => setState(() => is_owner = val)),
        _buildCardsGroup('what_to_ad'.tr, ['sale', 'rent'], purpose, (val) => setState(() => purpose = val)),
        _buildPropertyTypeGroup(),
        _buildCardsGroup('property_nature'.tr, ['tabo_shares', 'temp_record', 'court_ruling', 'housing_tabo', 'green_tabo', 'title_deed', 'sale_contract', 'agency', 'inheritance', 'gift', 'sorting', 'legal_record', 'formal_sorting', 'usufruct', 'signal'], property_nature, (val) => setState(() => property_nature = val)),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (['apartment', 'house', 'villa'].contains(type)) ...[
          _buildCardsGroup('bedrooms'.tr, ['studio', '1', '2', '3', '4', '5', '6+'], bedrooms , (val) => setState(() => bedrooms = val)),
          _buildCardsGroup('bathrooms'.tr, ['studio', '1', '2', '3', '4', '5', '6+'], bathrooms, (val) => setState(() => bathrooms = val)),
          _buildCardsGroup('floor'.tr, ['ground', '1_9', '10_plus', 'last_with_roof'], floor, (val) => setState(() => floor = val)),
          _buildAreaInput(),
          _buildCardsGroup('building_age'.tr, ['under_construction', '0_11_months', '1_5_years', '6_9_years', '10_19_years', '20_plus_years'], building_age, (val) => setState(() => building_age = val)),
          _buildCardsGroup('furnished'.tr, ['furnished', 'unfurnished', 'semi_furnished'], is_furnished, (val) => setState(() => is_furnished = val)),
          _buildCardsGroup('mortgaged'.tr, ['yes', 'no'], is_mortgaged, (val) => setState(() => is_mortgaged = val)),
        ] else if (['office', 'shop', 'restaurant', 'clinic', 'warehouse'].contains(type)) ...[
          _buildCardsGroup('floor'.tr, ['ground', '1_9', '10_plus'], floor, (val) => setState(() => floor = val)),
          _buildAreaInput(),
          _buildCardsGroup('property_status'.tr, ['ready', 'under_construction_status'], property_status, (val) => setState(() => property_status = val)),
          _buildCardsGroup('furnished'.tr, ['furnished', 'unfurnished', 'semi_furnished'], is_furnished, (val) => setState(() => is_furnished = val)),
          _buildCardsGroup('mortgaged'.tr, ['yes', 'no'], is_mortgaged, (val) => setState(() => is_mortgaged = val)),
        ] else if (['land', 'farm', 'block'].contains(type)) ...[
          _buildCardsGroup('designated_for'.tr, ['residential', 'commercial', 'agricultural', 'industrial', 'multi_use'], designated_for, (val) => setState(() => designated_for = val)),
          _buildAreaInput(),
          _buildCardsGroup('facade'.tr, ['north', 'south', 'east', 'west', 'northeast', 'northwest', 'southeast', 'southwest'], facade, (val) => setState(() => facade = val)),
        ],

        if (purpose == 'rent')
          _buildCardsGroup('rent_duration'.tr, ['daily', 'weekly', 'monthly', 'yearly'], rent_duration, (val) => setState(() => rent_duration = val)),
      ],
    );
  }

  // الخطوة الجديدة الخاصة بالموقع والخريطة
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('location_info'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff1f3c5a))),
        const SizedBox(height: 16),

        // المحافظة
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text('state'.tr, style: TextStyle(color: Colors.blueGrey.shade600)),
              items: states.isNotEmpty ? [
                for (var item in states)
                  DropdownMenuItem<String>(value: item['name_ar'].toString(), child: Text(item['name_ar'].toString()))
              ] : [],
              onChanged: (value) {
                setState(() { state = value ?? ''; city = ''; });
                getCitys();
              },
              value: state.isNotEmpty && states.any((item) => item['name_ar'].toString() == state) ? state : null,
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
              menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15), height: 50),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // المدينة
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text('city'.tr, style: TextStyle(color: Colors.blueGrey.shade600)),
              items: citys.isNotEmpty ? [
                for (var item in citys)
                  DropdownMenuItem<String>(value: item['name_ar'].toString(), child: Text(item['name_ar'].toString()))
              ] : [],
              onChanged: (value) {
                setState(() { city = value ?? ''; });
              },
              value: city.isNotEmpty && citys.any((item) => item['name_ar'].toString() == city) ? city : null,
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
              menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15), height: 50),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // العنوان التفصيلي
        _buildTextField(address, 'address'.tr, FontAwesomeIcons.locationArrow),
        const SizedBox(height: 24),

        Text('pin_on_map'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1f3c5a))),
        const SizedBox(height: 12),

        // الخريطة
        Container(
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            color: const Color(0xFFF1F2F4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(lat, lng),
                    initialZoom: 10,
                    onTap: (tapPosition, point) {
                      setState(() {
                        lat = point.latitude;
                        lng = point.longitude;
                      });
                    },
                  ),
                  children: [
                    TileLayer(urlTemplate: MAP_URL, userAgentPackageName: 'com.aldlaal.app'),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80,
                          height: 80,
                          point: LatLng(lat, lng),
                          child: Icon(FontAwesomeIcons.locationDot, color: Colors.redAccent, size: 50),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    child: _isLoadingLocation
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(FontAwesomeIcons.locationCrosshairs, color: const Color(0xff1f3c5a)),
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('tap_map_to_change_location'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(title, 'ad_title'.tr, FontAwesomeIcons.bullhorn, maxLength: 60),
        const SizedBox(height: 16),
        _buildTextField(description, 'ad_desc'.tr, FontAwesomeIcons.penToSquare, maxLines: 4),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(price, 'price'.tr, FontAwesomeIcons.moneyBillWave, isNumber: true)),
            const SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFFF1F2F4), borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: ['SYP', 'USD'].contains(curr) ? curr : 'SYP',
                  items: ['SYP', 'USD'].map((e) => DropdownMenuItem(value: e, child: Text(e.tr))).toList(),
                  onChanged: (val) => setState(() => curr = val!),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCardsGroup('payment_method'.tr, ['cash', 'installments'], payment_method, (val) => setState(() => payment_method = val)),
        const SizedBox(height: 16),
        Text('available_features'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1f3c5a))),
        const SizedBox(height: 8),
        _buildMultiChoiceGroup('main_features'.tr, ['central_ac', 'ac', 'heating', 'floor_heating', 'balcony'], main_features),
        _buildMultiChoiceGroup('internal_features'.tr, ['maid_room', 'laundry_room', 'wall_closets', 'double_glass', 'solar_heater', 'jacuzzi'], internal_features),
        _buildMultiChoiceGroup('appliances'.tr, ['oven', 'microwave', 'fridge', 'washer', 'dishwasher'], appliances),
        _buildMultiChoiceGroup('extra_features'.tr, ['elevator', 'parking', 'garden', 'storage', 'guard_security', 'backup_power', 'accessibility'], extra_features),
        const SizedBox(height: 16),
        _buildMultiChoiceGroup('nearby_places'.tr, ['bank_atm', 'supermarket', 'school', 'mosque', 'restaurant', 'hospital', 'mall', 'bus_station'], nearby_places),
      ],
    );
  }

  Widget _buildStep5() {
    final VideoSaver _videoSaver = VideoSaver();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: uploadedImages.length < 20 ? pickAndUploadImage : null,
            icon: Icon(FontAwesomeIcons.image, color: Colors.white),
            label: Text('${'add_images'.tr} (${uploadedImages.length}/20)', style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff1f3c5a),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (uploadedImages.isNotEmpty) _buildDraggableImageGrid(),

        const SizedBox(height: 10),
        Text('global_txt_92'.tr,style: TextStyle(fontSize: 12,color: Colors.grey,height: 1.5,letterSpacing: 0.3)),

        SizedBox(height: 30),
        Divider(),
        SizedBox(height: 10),
        Text("${'global_txt_89'.tr} ${'global_txt_91'.tr}",style: TextStyle(fontSize: 13,height: 2,letterSpacing: 1.0)),


        SizedBox(height: 5),
        Stack(
          children: [
            InkWell(
              customBorder: const CircleBorder(),
              onTap: _isLoading || video != '' ? null: () async{
                setState(() {_isLoading = true;});
                dynamic res;
                res = await _videoSaver.save();
                if(res != null && res['status'] == 1){
                  setState(() {
                    video = res['video_name'];
                  });
                }else{
                  //Get.snackbar('Sorry', 'Please try again', backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                }
                setState(() {_isLoading = false;});
              },
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.blueGrey.shade300),
                child: !_isLoading && video != '' ? VPlayer(videoUrl: '${API_URL}/uploads/videos/${video}') :
                !_isLoading ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(Icons.video_collection,size: 90,color: Colors.white),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(height: 10),
                    Text('Uploading...'.toUpperCase(),style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),
            !_isLoading && video != '' ? IconButton(onPressed: (){setState(() {video = '';});}, icon: Icon(Icons.close,color: Colors.redAccent,size: 30,)) : Container(),
          ],
        ),

        const SizedBox(height: 10),
        Text('global_txt_90'.tr,style: TextStyle(fontSize: 12,color: Colors.grey,height: 1.5,letterSpacing: 0.3)),
        const SizedBox(height: 10),


      ],
    );
  }

  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummarySection('basic_info'.tr, 1, {
          'publisher'.tr: is_owner?.tr,
          'ad_type'.tr: purpose?.tr,
          'property_type_lbl'.tr: type?.tr,
          'property_nature'.tr: property_nature?.tr
        }),
        _buildSummarySection('property_details'.tr, 2, {
          'area'.tr: '${area_m2 .text} ${area_unit .tr}',
          'bedrooms'.tr: bedrooms?.tr,
          'bathrooms'.tr: bathrooms?.tr,
          'floor'.tr: floor?.tr,
          'building_age'.tr: building_age?.tr,
          'property_status'.tr: property_status?.tr,
          'designated_for'.tr: designated_for?.tr,
          'facade'.tr: facade?.tr,
          'furnished'.tr: is_furnished?.tr,
          'mortgaged'.tr: is_mortgaged?.tr,
          'rent_duration'.tr: rent_duration?.tr,
        }),
        _buildSummarySection('location_info'.tr, 3, {
          'state'.tr: state,
          'city'.tr: city,
          'address'.tr: address.text,
        }),
        _buildSummarySection('financial_features'.tr, 4, {
          'ad_title'.tr: title.text,
          'ad_desc'.tr: description.text,
          'price'.tr: '${price.text} ${curr.tr}',
          'payment_method'.tr: payment_method?.tr,
          'main_features'.tr: main_features.map((e) => e.tr).join('، '),
          'internal_features'.tr: internal_features.map((e) => e.tr).join('، '),
          'appliances'.tr: appliances.map((e) => e.tr).join('، '),
          'extra_features'.tr: extra_features.map((e) => e.tr).join('، '),
          'nearby_places'.tr: nearby_places.map((e) => e.tr).join('، '),
        }),

        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text('estate_status'.tr),
                  items: estate_status_list.isNotEmpty ? [
                    for (var item in estate_status_list)
                      DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                  ] : [],
                  onChanged: (value) {
                    setState(() {
                      estate_status = value ?? '';
                    });},
                  value: estate_status.isNotEmpty && estate_status_list.any((item) => item.toString() == estate_status) ? estate_status : null,
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                  menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                  dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                  underline: SizedBox.shrink(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text('status'.tr),
                  items: status_list.isNotEmpty ? [
                    for (var item in status_list)
                      DropdownMenuItem<String>(value: item.toString(), child: Text(item.toString().tr ?? ''))
                  ] : [],
                  onChanged: (value) {
                    setState(() {
                      status = value ?? '';
                    });},
                  value: status.isNotEmpty && status_list.any((item) => item.toString() == status) ? status : null,
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                  menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                  dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                  underline: SizedBox.shrink(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // شبكة الصور قابلة للسحب
  Widget _buildDraggableImageGrid() {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 32 - 24) / 4; // 32 Padding, 24 Spacing

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(uploadedImages.length, (index) {
        return DragTarget<int>(
          onWillAccept: (data) => data != index,
          onAccept: (oldIndex) {
            setState(() {
              final item = uploadedImages.removeAt(oldIndex);
              uploadedImages.insert(index, item);
              if (mainImageIndex == oldIndex) mainImageIndex = index;
              else if (mainImageIndex > oldIndex && mainImageIndex <= index) mainImageIndex--;
              else if (mainImageIndex < oldIndex && mainImageIndex >= index) mainImageIndex++;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return LongPressDraggable<int>(
              data: index,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: itemWidth, height: itemWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                    image: DecorationImage(
                      image: NetworkImage("$API_URL/uploads/imgs/md/${uploadedImages[index]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: itemWidth, height: itemWidth,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
              child: SizedBox(
                width: itemWidth, height: itemWidth,
                child: _buildImageItemCard(index),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildImageItemCard(int index) {
    bool isMain = mainImageIndex == index;
    return GestureDetector(
      onTap: () => setState(() => mainImageIndex = index),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isMain ? Colors.green : Colors.grey.shade300, width: isMain ? 3 : 1),
                color: Colors.grey.shade100,
                image: DecorationImage(
                  image: NetworkImage("$API_URL/uploads/imgs/md/${uploadedImages[index]}"),
                  fit: BoxFit.cover,
                )
            ),
          ),
          if (isMain)
            Positioned(
              bottom: 4, right: 4, left: 4,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                child: Text('main_img'.tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          Positioned(
            top: -10, left: -10,
            child: IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                setState(() {
                  uploadedImages.removeAt(index);
                  if (mainImageIndex >= uploadedImages.length) mainImageIndex = 0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }


  // === عناصر التصميم (Widgets) ===

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1, int? maxLength}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: Colors.blueGrey.shade400, size: 20),
        label: Text(label, style: TextStyle(color: Colors.blueGrey.shade600)),
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        filled: true,
        fillColor: const Color(0xFFF1F2F4),
        counterText: "",
      ),
      inputFormatters: maxLength != null ? [LengthLimitingTextInputFormatter(maxLength)] : null,
      onChanged: (v) => setState(() {}),
    );
  }

  Widget _buildAreaInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('area'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1f3c5a))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextField(area_m2 , 'area_numbers'.tr, FontAwesomeIcons.chartArea, isNumber: true)),
              const SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F2F4), borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ['sqm', 'dunum'].contains(area_unit) ? area_unit : 'sqm',
                    items: ['sqm', 'dunum'].map((e) => DropdownMenuItem(value: e, child: Text(e.tr))).toList(),
                    onChanged: (val) => setState(() => area_unit  = val!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardsGroup(String title, List<String> options, String? selectedValue, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1f3c5a))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10.0, runSpacing: 10.0,
            children: options.map((opt) {
              bool isSelected = selectedValue == opt;
              return GestureDetector(
                onTap: () => onSelect(opt),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff1f3c5a) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? const Color(0xff1f3c5a) : Colors.grey.shade300, width: 1.5),
                  ),
                  child: Text(opt.tr, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : Colors.blueGrey.shade800)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeGroup() {
    final Map<String, IconData> propertyIcons = {
      'apartment': FontAwesomeIcons.building, 'house': FontAwesomeIcons.houseUser, 'building': FontAwesomeIcons.city,
      'villa': FontAwesomeIcons.houseChimneyWindow, 'land': FontAwesomeIcons.mapLocationDot, 'office': FontAwesomeIcons.buildingUser,
      'shop': FontAwesomeIcons.store, 'warehouse': FontAwesomeIcons.warehouse, 'farm': FontAwesomeIcons.tree,
      'restaurant': FontAwesomeIcons.utensils, 'clinic': FontAwesomeIcons.stethoscope,'block': FontAwesomeIcons.cube,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('property_type'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1f3c5a))),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
            ),
            itemCount: propertyIcons.length,
            itemBuilder: (context, index) {
              String key = propertyIcons.keys.elementAt(index);
              IconData icon = propertyIcons.values.elementAt(index);
              bool isSelected = type == key;

              return GestureDetector(
                onTap: () => setState(() => type = key),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff1f3c5a).withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? const Color(0xff1f3c5a) : Colors.grey.shade200, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 32, color: isSelected ? const Color(0xff1f3c5a) : Colors.amber.shade600),
                      const SizedBox(height: 8),
                      Text(key.tr, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: Colors.blueGrey.shade800)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMultiChoiceGroup(String title, List<String> options, Set<String> selectedValues) {
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
              bool isSelected = selectedValues.contains(opt);
              return GestureDetector(
                onTap: () {
                  setState(() { isSelected ? selectedValues.remove(opt) : selectedValues.add(opt); });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
                    border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[Icon(Icons.check, size: 16, color: Colors.green), SizedBox(width: 4)],
                      Text(opt.tr, style: TextStyle(fontSize: 13, color: isSelected ? Colors.green.shade800 : Colors.blueGrey.shade800)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, int step, Map<String, String?> data) {
    return Card(
      elevation: 0, color: const Color(0xFFF1F2F4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xff1f3c5a))),
                IconButton(
                  onPressed: () => editStep(step),
                  icon: Icon(FontAwesomeIcons.penToSquare, size: 18, color: Colors.blueGrey.shade400),
                  padding: EdgeInsets.zero, constraints: BoxConstraints(),
                )
              ],
            ),
            const Divider(),
            ...data.entries.where((e) => e.value != null && e.value!.isNotEmpty && e.value != 'null null').map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: Text('${e.key} ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey.shade600))),
                  Expanded(flex: 3, child: Text(e.value!, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                ],
              ),
            )).toList()
          ],
        ),
      ),
    );
  }
}