import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';
import '/widgets/topwg.dart';

class AgencySearchPage extends StatefulWidget {
  const AgencySearchPage({super.key});

  @override
  State<AgencySearchPage> createState() => _AgencySearchPageState();
}

class _AgencySearchPageState extends State<AgencySearchPage> {
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  String state = '';
  String city = '';
  late dynamic states = [];
  late dynamic citys = [];
  late dynamic agencies = [];
  TextEditingController search = TextEditingController();

  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/public/agency/get_page', {'page':page,'search':search.text,'state':state,'city':city});
    if(res != null && res['status'] == 1){
      setState(() {
        if (res['data'].length < 12) finalPage = true;
        page == 1 ? agencies = res['data'] : agencies.addAll(res['data']);
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }

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

  void initFields() async{
    await getStates();
    await getCitys();
    await getData();
  }

  @override
  void initState() {
    super.initState();
    initFields();
    _loadMoreController.addListener(() {if (_loadMoreController.offset == _loadMoreController.position.maxScrollExtent) {getData(skip:1);}});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('global_txt_86'.tr),
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
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  color: Color(0xFFF9F9FF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Column(
                          children: [
                            TextField(
                              controller: search,
                              onSubmitted: (value) async{await getData();},
                              keyboardType: TextInputType.text,
                              readOnly: false,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(FontAwesomeIcons.search, color: Colors.blueGrey[900]),
                                  onPressed: () async {await getData();},
                                ),
                                hintText: 'search...'.tr,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                filled: true, fillColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
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
                                      getData();
                                    },
                                    value: state.isNotEmpty && states.any((item) => item['name_ar'].toString() == state) ? state : null,
                                    buttonStyleData: ButtonStyleData(height: 50, padding: const EdgeInsets.only(left: 14, right: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.transparent),),),
                                    iconStyleData: IconStyleData(icon: Icon(FontAwesomeIcons.chevronDown, size: 16, color: Colors.blueGrey[900],),),
                                    menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15), height: 50,),
                                    dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white,),),
                                    underline: const SizedBox.shrink(),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
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
                                      getData();
                                    },
                                    value: city.isNotEmpty && citys.any((item) => item['name_ar'].toString() == city) ? city : null,
                                    buttonStyleData: ButtonStyleData(height: 50, padding: const EdgeInsets.only(left: 14, right: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.transparent),),),
                                    iconStyleData: IconStyleData(icon: Icon(FontAwesomeIcons.chevronDown, size: 16, color: Colors.blueGrey[900],),),
                                    menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15), height: 50,),
                                    dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white,),),
                                    underline: const SizedBox.shrink(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                !_isLoading && agencies.length != 0 ?
                Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width < 640 ? 3:4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 2,
                      childAspectRatio: 0.72,
                      padding: EdgeInsets.all(15),
                      children: List.generate(agencies.length, (idx) {
                        return AgencyCard(id: agencies[idx]['id'].toString(), name: agencies[idx]['name'], img: agencies[idx]['img']);
                      }),
                    ),
                    _isLoadMore ? Center(child: Container(width: 30, height: 30, margin: EdgeInsets.only(top: 5,bottom: 20), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2))) : Container(),
                  ],
                ) :
                !_isLoading && agencies.length == 0 ? Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Image.asset('assets/imgs/empty.png'),
                      SizedBox(height: 10),
                      Text('global_txt_87'.tr,style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ) : Center(child: Container(width: 50, height: 50, margin: EdgeInsets.symmetric(vertical: 200), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




