import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/config.dart';
import '/services/api_service.dart';
import '/services/img_saver.dart';

class VerfiryPage extends StatefulWidget {
  const VerfiryPage({super.key});
  @override
  State<VerfiryPage> createState() => _VerfiryPageState();
}

class _VerfiryPageState extends State<VerfiryPage> {
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late int activated = 0;
  late dynamic files = [];
  late List<Map<String, String>> doc_types = [
    {'id': 'id', 'text': 'بطاقة هوية'},
    {'id': 'passport', 'text': 'جواز سفر'},
    {'id': 'driver', 'text': 'رخصة سياقة'},
    {'id': 'license', 'text': 'ﻣﻠف ﺗرﺧﯾص اﻟﻣﻛﺗب'},
    {'id': 'others', 'text': 'وثائق أخرى'}
  ];
  late String doc_type = "";
  late String img = "";


  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = await apiService('/user/id_verify/get_all', {'page':page});
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 10) finalPage = true;
        activated = res['activated'];
        page == 1 ? files = res['data'] : files.addAll(res['data']);
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }


  void addFile(){
    if(files.length >= 10){
      Get.snackbar('sorry!'.tr, 'settings_txt_28'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
      return null;
    }
    setState(() {doc_type = '';img = '';});
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
                  constraints: const BoxConstraints(maxHeight: 425),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('settings_txt_29'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                            IconButton(icon: Icon(FontAwesomeIcons.close,size: 28,color: Colors.blueGrey[700]), onPressed: () {Get.back();}),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F2F4)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text('settings_txt_30'.tr),
                            items: doc_types.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'],
                                child: Text(item['text']!.toString().tr),
                              );
                            }).toList(),
                            onChanged: (value) {setState(() {doc_type = value ?? '';});},
                            value: doc_type.isNotEmpty ? doc_type : null,
                            buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(left: 8, right: 8)),
                            menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 15),height: 55),
                            dropdownStyleData: DropdownStyleData(padding: EdgeInsets.zero,decoration: BoxDecoration(color: Colors.white)),
                            underline: SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(height: 15),


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
                                  placeholder: (context, url) => Container(padding: EdgeInsets.all(20), child: Center(child: Container(height: 75, width: 75, child: CircularProgressIndicator(color: Colors.blue,strokeWidth: 3)))),
                                  errorWidget: (context, url, error) => Image.asset('assets/imgs/add.webp')) : Image.asset('assets/imgs/add.webp'),
                            ),
                          ),
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
                              if(doc_type != '' && img != ""){
                                var res = await apiService('/user/id_verify/add', {'doc_type':doc_type,'img':img});
                                if (res != null && res['status'] == 1) {
                                  getData();
                                  Get.back();
                                  Get.snackbar('success'.tr, 'settings_txt_32'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                                }else{
                                  Get.back();
                                  Get.snackbar('sorry!'.tr, 'try_again'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                                }
                              }else{
                                Get.snackbar('sorry!'.tr, 'settings_txt_31'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
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
        title: Text('settings_txt_41'.tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blueGrey.withOpacity(0.2),
        elevation: 8,
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.blueGrey.shade700),
          onPressed: () async {
            if(Get.previousRoute.isNotEmpty){
              Get.back();
            }else{
              String firstRoute = await getFirstRoute();
              Get.offAllNamed(firstRoute);
            }
          },
        ),
      ),
      floatingActionButton: !_isLoading && activated == 0 ? FloatingActionButton(
        onPressed: addFile,
        backgroundColor: Colors.blue,
        child: const Icon(FontAwesomeIcons.plus,color: Colors.white),
      ) : null,
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: getData,
        child: SingleChildScrollView(
          controller: _loadMoreController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child: Column(
              children: [

                Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.idCard,color: Colors.blueGrey[700],),
                            const SizedBox(width: 5),
                            Text('settings_txt_33'.tr,style: TextStyle(fontSize: 20)),
                            const Spacer(),
                            !_isLoading ? Text(activated == 1 ? 'settings_txt_34'.tr : 'settings_txt_35'.tr,style: const TextStyle(fontSize: 20)):Container(),
                            const SizedBox(width: 5),
                            !_isLoading ? Icon(FontAwesomeIcons.solidCircle,color: activated == 1 ? Colors.green : Colors.redAccent,size: 18,):Container(),
                          ],
                        ),
                        !_isLoading && activated == 0 ? Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text('settings_txt_36'.tr),
                              SizedBox(height: 5),
                              Text('settings_txt_37'.tr),
                              SizedBox(height: 5),
                              Text('settings_txt_38'.tr),
                              SizedBox(height: 5),
                              Text('settings_txt_39'.tr),
                            ],
                          ),
                        ) : Container()
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey[300]),



                !_isLoading && files.length != 0 ?
                Column(
                    children: [
                      for(var i=0;i<files.length;i++)
                        fileCard(files[i]['id'],files[i]['doc_type'],files[i]['img'],files[i]['active'],files[i]['date'],getData),
                    ]
                ) :
                !_isLoading && files.length == 0 ? Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        SizedBox(width: 200,child: Image.asset('assets/imgs/id_verify.webp')),
                        const SizedBox(height: 10),
                        Text('settings_txt_27'.tr,style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text('settings_txt_28'.tr,style: TextStyle(fontSize: 14,color: Colors.grey)),
                      ],
                    ),
                  ),
                ) : Center(child: Container(width: 75, height: 75, margin: const EdgeInsets.symmetric(vertical: 150), child: const CircularProgressIndicator(color: Colors.blue,strokeWidth: 3))),






              ],
            ),
          ),
        ),
      ),
    );
  }
}


class fileCard extends StatelessWidget {
  final int id;
  final String doc_type;
  final String img;
  final int active;
  final String date;
  final VoidCallback onRefresh;
  const fileCard(this.id,this.doc_type,this.img,this.active,this.date,this.onRefresh);


  void DeleteFile(){
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(10,10,10,0),
        actionsPadding: const EdgeInsets.fromLTRB(10,0,10,10),
        backgroundColor: Colors.white,
        title: Text('settings_txt_40'.tr,style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async{
              var res = await apiService('/user/id_verify/remove', {'id':id});
              if(res != null && res['status'] == 1){
                Get.back();
                onRefresh();
              }else{
                Get.back();
              }
            },
            child: Text("delete".tr),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFFf5f5f5),
      child: InkWell(
        onTap: active != 1 ? (){
          DeleteFile();
        } : null,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc_type),
                      SizedBox(height: 5),
                      Text(date),
                    ],
                  ),
                ),
              ),
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    active == 1 ? Icon(FontAwesomeIcons.circleCheck,size: 28,color: Colors.green) :
                    active == 0 ? Icon(FontAwesomeIcons.ban,size: 28,color: Colors.redAccent): Icon(FontAwesomeIcons.clock,size: 28,color: Colors.amber),
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
