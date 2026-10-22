import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/img_saver.dart';
import '/services/api_service.dart';
import '/config.dart';

class AgencyProfilePage extends StatefulWidget {
  const AgencyProfilePage({super.key});

  @override
  State<AgencyProfilePage> createState() => _AgencyProfilePageState();
}

class _AgencyProfilePageState extends State<AgencyProfilePage> {
  late bool _isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  late String img = "";
  late String cover = "";
  late String status = "active";
  late String address = "";
  late String phone = "";
  late String email = "";

  String state = '';
  String city = '';
  dynamic states = [];
  dynamic citys = [];

  Future<void> getStates() async{
    var res = await apiService('/others/get_states', {});
    if(res != null && res['status'] == 1){
      setState(() {states = res['data'];});
    }
  }
  Future<void> getCitys() async{
    setState(() {city = '';});
    var res = await apiService('/others/get_citys', {'state': state});
    if(res != null && res['status'] == 1){
      setState(() {citys = res['data'];});
    }
  }

  Future<void> getData() async {
    setState(() {_isLoading = true;});
    var res = await apiService('/agency/agency/get_info', {});
    if(res != null && res['status'] == 1){
      setState(() {
        name.text = res['data']['name'];
        description.text = res['data']['description'];
        state = res['data']['state'];
        city = res['data']['city'];
        img = res['data']['img'];
        cover = res['data']['cover'];
        status = res['data']['status'];
        address = res['data']['address'];
        phone = res['data']['phone'];
        email = res['data']['email'];
        _isLoading = false;
      });
    }else{setState(() {_isLoading = false;});}
  }

  Future<void> edit() async{
    setState(() {_isLoading = true;});

    /*else if(img == ''){
    Get.snackbar('sorry!'.tr, 'global_txt_81'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
    }*/

    if(name.text == ''){
      Get.snackbar('sorry!'.tr, 'global_txt_80'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
    }else{
      var res = await apiService('/agency/agency/edit', {
        'name': name.text,
        'description': description.text,
        'state': state,
        'city': city,
        'img': img,
        'cover': cover,
        'email': email,
        'phone': phone,
        'address': address,
        'status': status
      });
      if(res != null && res['status'] == 1){
        Get.back();
        Get.snackbar('success'.tr, 'global_txt_82'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
      }else{
        Get.snackbar('sorry!'.tr, 'global_txt_83'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
      }
      print("$res");
    }
    await fetch_user_data();
    setState(() {_isLoading = false;});
  }

  void initFields() async{
    await getData();
    await getStates();
    await getCitys();
  }

  @override
  void initState() {
    super.initState();
    initFields();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('global_txt_56'.tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blueGrey.withOpacity(0.2),
        elevation: 8,
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.blueGrey.shade900),
          onPressed: () {Get.back();},
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),
              TextField(
                controller: name,
                keyboardType: TextInputType.text,
                maxLength: 60,
                decoration: InputDecoration(
                  suffixIcon: Icon(FontAwesomeIcons.store),
                  label: Text('name'.tr),
                  hintText: 'name'.tr,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  filled: true, fillColor: const Color(0xFFF1F2F4),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(60),
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                controller: description,
                maxLines: 4,
                maxLength: 500,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'description'.tr,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  filled: true, fillColor: const Color(0xFFF1F2F4),
                  focusColor: Colors.amber,
                ),
                onTap: (){},
              ),
              const SizedBox(height: 15),
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
                    getCitys();
                  },
                  value: state.isNotEmpty && states.any((item) => item['name_ar'].toString() == state) ? state : null,
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                  menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                  dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                  underline: SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 15),
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
                    setState(() {
                      city = value ?? '';
                    });},
                  value: city.isNotEmpty && citys.any((item) => item['name_ar'].toString() == city) ? city : null,
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 4, right: 0)),
                  menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                  dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                  underline: SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 15),
              Text('global_txt_84'.tr,style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () async{
                  var img_name = await ImageSaver().Save();
                  if(img_name != null){
                    setState(() {img = img_name;});
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: img != '' ? CachedNetworkImage(
                        imageUrl: '${API_URL}/uploads/imgs/md/${img}',
                        imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                        placeholder: (context, url) => Container(padding: EdgeInsets.all(20), child: Center(child: Container(height: 75, width: 75, child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3)))),
                        errorWidget: (context, url, error) => Image.asset('assets/imgs/add.webp')) : Image.asset('assets/imgs/add.webp'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('global_txt_92'.tr,style: TextStyle(fontSize: 12,color: Colors.grey,height: 1.5,letterSpacing: 0.3)),
              const SizedBox(height: 15),
              Text('global_txt_85'.tr,style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () async{
                  var img_name = await ImageSaver().Save();
                  if(img_name != null){
                    setState(() {cover = img_name;});
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: cover != '' ? CachedNetworkImage(
                        imageUrl: '${API_URL}/uploads/imgs/md/${cover}',
                        imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                        placeholder: (context, url) => Container(padding: EdgeInsets.all(20), child: Center(child: Container(height: 75, width: 75, child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3)))),
                        errorWidget: (context, url, error) => Image.asset('assets/imgs/add.webp')) : Image.asset('assets/imgs/add.webp'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('global_txt_93'.tr,style: TextStyle(fontSize: 12,color: Colors.grey,height: 1.5,letterSpacing: 0.3)),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !_isLoading ? (){
                    edit();
                  } : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('save'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              SizedBox(height: 5),



            ],
          ),
        ),
      ),
    );
  }
}
