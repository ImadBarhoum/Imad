import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../config.dart';
import '../../../services/api_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late String auth = box.hasData('auth') ? box.read('auth') : '0';
  Timer? _timer;
  late bool _isLoading = true;
  late bool _isLoadMore = true;
  final ScrollController _loadMoreController = ScrollController();
  late bool finalPage = false;
  late int page = 1;
  late dynamic chats = [];


  Future<void> getData({int skip = 0}) async {
    if(skip == 0){page = 1;finalPage=false;}
    if (page == 1) {setState(() => _isLoading = true);} else {setState(() => _isLoadMore = true);}
    if (finalPage) {setState(() {_isLoading = false;_isLoadMore = false;});return;}

    var res = await apiService('/user/chats/get_chats', {'page':page});
    if (res != null && res['status'] == 1) {
      setState(() {
        if (res['data'].length < 10) finalPage = true;
        page == 1 ? chats = res['data'] : chats.addAll(res['data']);
        page++;
      });
    }
    setState(() {_isLoading = false;_isLoadMore = false;});
  }

  void updateStatus() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async{
      var res = await apiService('/user/chats/get_chats', {'page':1});
      if (res != null && res['status'] == 1) {
        var data = res['data'].reversed.toList();
        for(int x=0;x<data.length;x++){
          final index = chats.indexWhere((o) => o['id'] == data[x]['id']);
          if (index != -1) {
            setState(() {chats[index] = data[x];});
          } else {
            setState(() {chats.insert(0, data[x]);});
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    updateStatus();
    _loadMoreController.addListener(() {if (_loadMoreController.offset == _loadMoreController.position.maxScrollExtent) {getData(skip: 1);}});
  }

  @override
  void dispose() {
    _loadMoreController.dispose();
    _timer?.cancel();
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
                  SizedBox(height: 10),
                  !_isLoading && chats.length != 0 ?
                  Column(
                      children: [
                        for (var i=0;i < chats.length;i++)
                          ChatCard(chats[i]['user_id'],chats[i]['ads_img'],chats[i]['ads_title'],chats[i]['msg'],chats[i]['time'],chats[i]['read'],chats[i]['ads_id'],chats[i]['type']),
                      ]
                  ) :
                  !_isLoading && chats.length == 0 ? Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          Container(width: 200,child: Image.asset('assets/imgs/no_chat.webp')),
                          SizedBox(height: 10),
                          Text('home_txt_3'.tr,style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('home_txt_4'.tr,style: TextStyle(fontSize: 14,color: Colors.grey)),
                        ],
                      ),
                    ),
                  ) : Center(child: Container(width: 50, height: 50, margin: EdgeInsets.symmetric(vertical: 250), child: CircularProgressIndicator(color: Color(0xff1f3c5a),strokeWidth: 3))),
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
          ]),
      ),
    );
  }
}




class ChatCard extends StatelessWidget {
  final int id;
  final int ads_id;
  final String img;
  final String name;
  final String msg;
  final String time;
  final int read;
  final String type;
  const ChatCard(this.id,this.img,this.name,this.msg,this.time,this.read, this.ads_id, this.type);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shadowColor: Colors.blueGrey.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){
          Get.toNamed('/chat',arguments: {'id':ads_id.toString(),'chat_id':id.toString(),'type':type});
        },
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  child: img != '' ? CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/sm/${img}', imageBuilder: (context, imageProvider) => CircleAvatar(radius: 75, backgroundImage: imageProvider,backgroundColor: Colors.white,), placeholder: (context, url) => Container(color: Colors.white,padding: EdgeInsets.all(20),child: const CircularProgressIndicator(color: Colors.orangeAccent,strokeWidth: 2,)), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')):Image.asset('assets/imgs/no_img.webp'),
                  radius: 30,
                )
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name,style: TextStyle(fontSize: 16)),
                        Spacer(),
                        read == 0 ? Icon(FontAwesomeIcons.solidCircle,color: Colors.blueAccent,size: 10) : Container(),
                        SizedBox(width: 5),
                        Text(time,style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Text(msg,style: TextStyle(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),
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
