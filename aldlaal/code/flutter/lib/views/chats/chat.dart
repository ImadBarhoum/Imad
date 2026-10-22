import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/img_saver.dart';
import '/services/api_service.dart';
import '/config.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final id = (Get.arguments != null && Get.arguments.containsKey('id')) ? Get.arguments['id'] : '';
  final chat_id = (Get.arguments != null && Get.arguments.containsKey('chat_id')) ? Get.arguments['chat_id'] : '';
  final type = (Get.arguments != null && Get.arguments.containsKey('type')) ? Get.arguments['type'] : '';
  Timer? _timer;
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  late bool _btnonsend = false;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late int rate = 0;

  bool _isMessageEmpty = true;
  final TextEditingController _msg = TextEditingController();
  late String title = "";
  late dynamic _messages = [];


  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}
    var res = {};
    if(type == "agency"){
      res = await apiService('/agency/chats/get_chat', {'page':page,'id':chat_id,'ads_id':id});
    }else{
      res = await apiService('/user/chats/get_chat', {'page':page,'id':id});
    }
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 12) finalPage = true;
        if(page == 1){
          title = res['title'];
          rate = res['rate'];
          _messages = res['data'];
        }else{
          _messages = res['data'] + _messages;
        }
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }

  Future<void> syncData() async{
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      var res = {};
      if(type == "agency"){
        res = await apiService('/agency/chats/sync_chat', {'id':chat_id,'ads_id':id});
      }else{
        res = await apiService('/user/chats/sync_chat', {'id':id});
      }
      if (res != null && res['status'] == 1) {
        if(res['read'] == 1){setState(() {for (var item in _messages) {if (item['read'] == 0) {item['read'] = 1;}}});}
        for(var x=0;x<res['data'].length;x++){
          if(_messages.any((element) => element['id'] == res['data'][x]['id']) == false){
            setState(() {_messages.add(res['data'][x]);});
          }
        }
      }
    });
  }

  Future<void> deleteMsg(int id) async{
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(15,20,15,10),
        actionsPadding: const EdgeInsets.fromLTRB(10,10,10,10),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,size: 40,color: Colors.black,),
        backgroundColor: Colors.white,
        title: Text('chat_txt_5'.tr),
        content: Text('chat_txt_6'.tr),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async{
              var res = {};
              if(type == "agency"){
                res = await apiService('/agency/chats/delete_msg', {'id':id});
              }else{
                res = await apiService('/user/chats/delete_msg', {'id':id});
              }
              if(res != null && res['status'] == 1){
                setState(() {_messages.removeWhere((message) => message['id'] == id);});
                Get.back();
              }
            },
            child: Text("delete".tr),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async{
    setState(() {_btnonsend = true;});
    if (_msg.text.isNotEmpty) {
      var res = {};
      if(type == "agency"){
        res = await apiService('/agency/chats/send_msg', {'id':chat_id,'ads_id':id,'msg':_msg.text});
      }else{
        res = await apiService('/user/chats/send_msg', {'id':id,'msg':_msg.text});
      }
      setState(() {
        String formattedTime = DateFormat('HH:mm').format(DateTime.now());
        _messages.add({"id":res['id'], "sender": "me","msg": _msg.text,"img":"","time": formattedTime,"read":0});
        _btnonsend = false;
      });
      _msg.clear();
    }
  }
  Future<void> _sendImg() async{
    var img_name = await ImageSaver().Save();
    if(img_name != null){
      var res = {};
      if(type == "agency"){
        res = await apiService('/agency/chats/send_msg', {'id':chat_id,'ads_id':id,'img':img_name});
      }else{
        res = await apiService('/user/chats/send_msg', {'id':id,'img':img_name});
      }
      setState(() {
        String formattedTime = DateFormat('HH:mm').format(DateTime.now());
        _messages.add({"id":res['id'], "sender": "me","msg": "","img":img_name,"time": formattedTime,"read":0});
      });
    }
  }

  void addReview(){
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 190),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('chat_txt_8'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                        IconButton(icon: Icon(FontAwesomeIcons.close,size: 28,color: Colors.blueGrey[700]), onPressed: () {Get.back();}),
                      ],
                    ),
                    //const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: rate.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber,),
                      onRatingUpdate: (rating) {
                        setState(() {rate = rating.toInt();});
                      },
                    ),
                    Spacer(),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1f3c5a),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async{
                          if(rate == 0){
                            Get.snackbar('sorry!'.tr, 'chat_txt_9'.tr, backgroundColor: Colors.orangeAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                          }else{
                            var res = await apiService('/user/chats/add_review', {'id':id,'rate':rate});
                            if(res != null && res['status'] == 1){
                              Get.back();
                              Get.snackbar('success'.tr, 'chat_txt_10'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                              getData();
                            }
                          }
                        },
                        child: Text('rate'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
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

  }

  @override
  void initState() {
    super.initState();
    getData();
    _loadMoreController.addListener(() {if (_loadMoreController.offset == _loadMoreController.position.maxScrollExtent) {getData(skip: 1);}});
    _msg.addListener(() {setState(() {_isMessageEmpty = _msg.text.isEmpty;});});
    syncData();
  }

  @override
  void dispose() {
    _loadMoreController.dispose();
    _msg.dispose();
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: !_isLoading ? Text(title != '' ? title : 'chat_txt_7'.tr,style: TextStyle(color: Colors.white)):Center(),
        centerTitle: true,
        leadingWidth: 77,
        backgroundColor: Color(0xff1f3c5a),
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: type == 'agency' ? Container() : IconButton(
              onPressed: addReview,
              icon: Icon(FontAwesomeIcons.solidStar,size: 28,color: Colors.amber),
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(box.read('lang') == 'en' ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight,size: 28,color: Colors.white),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {Get.back();} else {Get.offAllNamed('/home');}
          },
        ),
      ),
      body: Container(
        child: !_isLoading && title != '' ?
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  controller: _loadMoreController,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - 1 - index];
                    return Align(
                      alignment: message['sender'] == "me" ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: (){
                          if(message['sender'] == "me"){deleteMsg(message['id']);}
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: index == _messages.length-1 ? 20:5,bottom: index == 0 ? 20:5),
                          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                          decoration: BoxDecoration(
                            color: message['sender'] == "me" ? Colors.amber[50] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              message['msg'] != '' ? Text(message['msg'] ?? '', style: TextStyle(fontSize: 16)) :
                              message['img'] != '' ? Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                      imageUrl: '${API_URL}/uploads/imgs/md/${message['img']}',
                                      imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.contain))),
                                      placeholder: (context, url) => Container(padding: EdgeInsets.all(20), child: Center(child: Container(height: 50, width: 50, child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2)))),
                                      errorWidget: (context, url, error) => Center(child: Text('error!'.tr))),
                                ),
                              ) : Center(child: Text('error!'.tr)),
                              SizedBox(height: 8),
                              Container(
                                child: Wrap(
                                  children: [
                                    Icon(message['read'] == 1 ? FontAwesomeIcons.checkDouble : FontAwesomeIcons.check,color: Colors.grey[600],size: 16),
                                    SizedBox(width: 5),
                                    Text(message['time'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10,bottom: 15,right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: Offset(0, -2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msg,
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "chat_txt_3".tr,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400, width: 1),),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade600, width: 1),),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  !_isMessageEmpty ? IconButton(icon: Icon(FontAwesomeIcons.solidPaperPlane,size: 26), onPressed: _btnonsend ? null : _sendMessage, color: Color(0xff1f3c5a))
                      : IconButton(icon: Icon(FontAwesomeIcons.images,size: 26), onPressed: _btnonsend ? null : _sendImg, color: Color(0xff1f3c5a))
                ],
              ),
            ),
          ],
        ) :
        !_isLoading ? Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              SizedBox(height: 100),
              Container(padding: EdgeInsets.symmetric(horizontal: 50),child: Image.asset('assets/imgs/no_chat.webp')),
              SizedBox(height: 10),
              Text('chat_txt_4'.tr,style: TextStyle(fontSize: 18)),
            ],
          ),
        ) : Center(child: Container(width: 50, height: 50, margin: EdgeInsets.symmetric(vertical: 200), child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2))),
      ),
    );
  }
}
