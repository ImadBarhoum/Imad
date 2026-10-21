import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '/services/api_service.dart';
import '/config.dart';



class SliderWidget extends StatelessWidget {
  final double aspectRatio;
  final bool box;
  final dynamic carousel;
  const SliderWidget({super.key, this.carousel, this.aspectRatio = 21/9, this.box = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: box ? 0:0),
      child: Column(
        children: [
          carousel.length == 0 ? Container() :
          carousel.length == 1 ? AspectRatio(
            aspectRatio: aspectRatio,
            child: carousel[0]['img'] != '' ? ClipRRect(
              borderRadius: BorderRadius.circular(box ? 10:0),
              child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/lg/${carousel[0]['img']}',fit: BoxFit.cover,placeholder: (context, url) =>
                  Center(child: Container(width: 35, height: 35, child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2)),
                  ), errorWidget: (context, url, error) => Container(padding: EdgeInsets.only(top: 0),child: Image.asset('assets/imgs/no_img.webp'))),
            ) : Container(padding: EdgeInsets.only(top: 0),child: Image.asset('assets/imgs/no_img.webp')),
          ) : CarouselSlider.builder(
            itemCount: carousel.length,
            itemBuilder: (context, index, realIdx) {
              return GestureDetector(
                onTap: () async{
                  if(carousel[index]['route'] == 'ads'){
                    Get.toNamed('/ads/one',arguments: {'id':carousel[index]['route_id']});
                  }else if(carousel[index]['route'] == 'link'){
                    final Uri url = Uri.parse(carousel[index]['route_id']);
                    if (!await launchUrl(url)) {throw Exception('Could not launch');}
                  }
                },
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: carousel[index] != ''
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(box ? 10:0),
                    child: CachedNetworkImage(
                      imageUrl: '$API_URL/uploads/imgs/lg/${carousel[index]['img']}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: SizedBox(
                              width: 35,
                              height: 35,
                              child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2))),
                      errorWidget: (context, url, error) => Container(
                        padding: const EdgeInsets.only(top: 0),
                        child: Image.asset('assets/imgs/no_img.webp'),),),)
                      : Container(
                    padding: const EdgeInsets.only(top: 0),
                    child: Image.asset('assets/imgs/no_img.webp'),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: aspectRatio,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 5),
            ),
          ),
        ],
      ),
    );
  }
}

class AdsCard extends StatefulWidget {
  final String id;
  final String owner_id;
  final String phone;
  final String agency;
  final String title;
  final String price;
  final String curr;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String date;
  final String location;
  final String img;
  final dynamic imgs;
  final int is_fav;
  final VoidCallback? onRefresh;
  const AdsCard({super.key, required this.id, required this.owner_id, required this.phone, required this.agency, required this.title, required this.price, required this.curr, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.date, required this.location, required this.img, required this.imgs, this.onRefresh, required this.is_fav});

  @override
  State<AdsCard> createState() => _AdsCardState();
}
class _AdsCardState extends State<AdsCard> {
  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat.currency(locale: 'en_US', symbol: '',decimalDigits: 0);
    String user_id = box.hasData('user_id') ? box.read('user_id') : '';
    late int isFavSet = widget.is_fav;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: (){
            Get.toNamed('/ads/one',arguments: {'id':widget.id},preventDuplicates: false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2),),],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                _buildImageSection(),
                // Info Section
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text("${currency.format(double.parse(widget.price))} ${widget.curr.tr}", style: TextStyle(color: Color(0xFFD32F2F),fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      // Title
                      Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 6),
                      // Description
                      Text(
                          "${widget.bedrooms} ${"bedrooms".tr}, ${widget.bathrooms} ${"bathrooms".tr}, ${widget.garages} ${"garages".tr}, ${"size".tr} ${widget.area_m2} m²",
                          style: TextStyle(color: Colors.black, fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 12),
                      // Location and Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.location, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          Text(widget.date, style: TextStyle(color: Colors.grey[600], fontSize: 13))
                        ],
                      ),
                    ],
                  ),
                ),

                // Buttons Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    children: [
                      // Call Button
                      Expanded(
                        flex: 4,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if(widget.phone != "0"){
                              var url = 'tel:+${widget.phone}';
                              if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));}
                            }
                          },
                          icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                          label: Text("call".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1f3c5a),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat Button
                      Expanded(
                        flex: 3,
                        child: OutlinedButton.icon(
                          onPressed: user_id == widget.owner_id ? null : () {
                            if(box.hasData('auth') && box.read('auth') == '1'){
                              Get.toNamed('/chat',arguments: {'id':widget.id});
                            }else{
                              Get.snackbar('sorry!'.tr, 'settings_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                            }
                          },
                          icon: const Icon(Icons.chat_bubble, size: 18),
                          label: Text("chat".tr, style: TextStyle(fontWeight: FontWeight.bold),),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff1f3c5a),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xff1f3c5a)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Favorite
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8),),
                        child: IconButton(
                          icon: Icon(isFavSet == 1 ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,size: 26,color: Colors.redAccent),
                          onPressed: () async{
                            var res = await apiService('/user/properties/set_fav', {'id':widget.id});
                            if(res != null && res['status'] == 1){
                              setState(() {
                                isFavSet = isFavSet == 1 ? 0:1;
                              });
                            }else{
                              Get.snackbar('sorry!'.tr, 'ads_txt_8'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                            }
                          },
                          padding: EdgeInsets.zero,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    var total_imgs = widget.img != '' ? widget.imgs.length : widget.imgs.length;
    String main_img = widget.img != '' ? widget.img : (widget.imgs.length != 0 ? widget.imgs[0] : '');
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),),
          child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${main_img}',fit: BoxFit.cover,height: 220,width: double.infinity, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
        ),
        Positioned(bottom: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Icon(Icons.videocam, color: Colors.white, size: 16),
                //SizedBox(width: 8), // Divider space
                //Text("|", style: TextStyle(color: Colors.white54),),
                //SizedBox(width: 8),
                Text("${total_imgs}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(width: 4),
                Icon(Icons.image, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        //const Positioned(top: 10, left: 10, child: Opacity(opacity: 0.8, child: Text("الدلال", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)],),),),),
        Center(child: Padding(padding: const EdgeInsets.only(top: 20), child: Opacity(opacity: 0.5, child: Image.asset('assets/logo_white.png', width: 120, height: 120)),))
      ],
    );
  }
}
/*
class AdsCard extends StatelessWidget {
  final String id;
  final String agency;
  final String title;
  final String price;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String img;
  final VoidCallback? onRefresh;
  const AdsCard({super.key, required this.id, required this.agency, required this.title, required this.price, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.img, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0);
    var curr = box.hasData('currency') ? box.read("currency").toString() : 'SYP';
    var exchange = box.hasData('exchange') ? box.read("exchange") : '1';
    var echange_price = curr == 'USD' ? formatter.format(double.parse(price)/double.parse(exchange)) : formatter.format(double.parse(price));

    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: (){
        Get.toNamed('/ads/one',arguments: {'id':id},preventDuplicates: false);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child: AspectRatio(aspectRatio: 4/3, child: img != '' ? ClipRRect(child:
              Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${img}',fit: BoxFit.cover, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
                  Center(child: Opacity(opacity: 0.4, child: Image.asset('assets/logo_white.png', width: 120, height: 120))),
                ],
              ),borderRadius: BorderRadius.circular(10)) : Image.asset('assets/imgs/no_img.webp')),
            ),
            Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  area_m2 != '' ? Chip(
                    label: Row(
                      children: [
                        Icon(FontAwesomeIcons.layerGroup, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text("$area_m2 ${'ads_txt_2'.tr}",style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300)),
                    backgroundColor: Colors.white,
                  ):Container(),
                  SizedBox(width: 5),
                  bedrooms != '' ? Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bed, size: 18, color: Colors.grey[700]),
                        const SizedBox(width: 6),
                        Text(bedrooms, style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300),),
                    backgroundColor: Colors.white,
                  ):Container(),
                  SizedBox(width: 5),
                  bathrooms != '' ? Chip(
                    label: Row(
                      children: [
                        Icon(FontAwesomeIcons.shower, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(bathrooms,style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300)),
                    backgroundColor: Colors.white,
                  ):Container(),
                  SizedBox(width: 5),
                  garages != '' ? Chip(
                    label: Row(
                      children: [
                        Icon(FontAwesomeIcons.warehouse, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(garages,style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300)),
                    backgroundColor: Colors.white,
                  ):Container(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 19),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                  Row(
                    children: [
                      Text("$echange_price ${curr.tr}", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),maxLines: 1),
                      Spacer(),
                      ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(Color(0xff1f3c5a)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        ),
                        child: Text('global_txt_39'.tr,style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

class AdsCardSmall extends StatefulWidget {
  final String id;
  final String owner_id;
  final String phone;
  final String agency;
  final String title;
  final String price;
  final String curr;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String date;
  final String location;
  final String img;
  final dynamic imgs;
  final int is_fav;
  final VoidCallback? onRefresh;
  const AdsCardSmall({super.key, required this.id, required this.owner_id, required this.phone, required this.agency, required this.title, required this.price, required this.curr, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.date, required this.location, required this.img, required this.imgs, this.onRefresh, required this.is_fav});

  @override
  State<AdsCardSmall> createState() => _AdsCardSmallState();
}
class _AdsCardSmallState extends State<AdsCardSmall> {
  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat.currency(locale: 'en_US', symbol: '',decimalDigits: 0);
    String user_id = box.hasData('user_id') ? box.read('user_id') : '';
    late int isFavSet = widget.is_fav;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: (){
            Get.toNamed('/ads/one',arguments: {'id':widget.id},preventDuplicates: false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2),),],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                _buildImageSection(),
                // Info Section
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text("${currency.format(double.parse(widget.price))} ${widget.curr.tr}", style: TextStyle(color: Color(0xFFD32F2F),fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 3),
                      // Title
                      Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),maxLines: 1,overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      // Description
                      Text(
                          "${widget.bedrooms} ${"bedrooms".tr}, ${widget.bathrooms} ${"bathrooms".tr}, ${widget.garages} ${"garages".tr}, ${"size".tr} ${widget.area_m2} m²",
                          style: TextStyle(color: Colors.black, fontSize: 12, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      // Location and Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.location, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          //Text(widget.date, style: TextStyle(color: Colors.grey[600], fontSize: 13))
                        ],
                      ),
                    ],
                  ),
                ),

                Spacer(),
                // Buttons Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 3),
                  child: Row(
                    children: [
                      // Call Button
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            if(widget.phone != "0"){
                              var url = 'tel:+${widget.phone}';
                              if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));}
                            }
                          },
                          icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1f3c5a),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat Button
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: user_id == widget.owner_id ? null : () {
                            if(box.hasData('auth') && box.read('auth') == '1'){
                              Get.toNamed('/chat',arguments: {'id':widget.id});
                            }else{
                              Get.snackbar('sorry!'.tr, 'settings_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                            }
                          },
                          icon: const Icon(Icons.chat_bubble, size: 18),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff1f3c5a),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            side: const BorderSide(color: Color(0xff1f3c5a)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Favorite
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: IconButton(
                            icon: Icon(isFavSet == 1 ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,size: 18,color: Colors.redAccent),
                            onPressed: () async{
                              var res = await apiService('/user/properties/set_fav', {'id':widget.id});
                              if(res != null && res['status'] == 1){
                                setState(() {
                                  isFavSet = isFavSet == 1 ? 0:1;
                                });
                              }else{
                                Get.snackbar('sorry!'.tr, 'ads_txt_8'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            padding: EdgeInsets.zero,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    var total_imgs = widget.img != '' ? widget.imgs.length+1 : widget.imgs.length;
    String main_img = widget.img != '' ? widget.img : (widget.imgs.length != 0 ? widget.imgs[0] : '');
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),),
          child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${main_img}',fit: BoxFit.cover,height: 140,width: double.infinity, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
        ),
        Positioned(bottom: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Icon(Icons.videocam, color: Colors.white, size: 16),
                //SizedBox(width: 8), // Divider space
                //Text("|", style: TextStyle(color: Colors.white54),),
                //SizedBox(width: 8),
                Text("${total_imgs}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(width: 4),
                Icon(Icons.image, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        //const Positioned(top: 10, left: 10, child: Opacity(opacity: 0.8, child: Text("الدلال", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)],),),),),
        Center(child: Padding(padding: const EdgeInsets.only(top: 40), child: Opacity(opacity: 0.5, child: Image.asset('assets/logo_white.png', width: 60, height: 60)),))
      ],
    );
  }
}

class AdsCardSlider extends StatelessWidget {
  final String id;
  final String agency;
  final String title;
  final String price;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String img;
  final VoidCallback? onRefresh;
  const AdsCardSlider({super.key, required this.id, required this.agency, required this.title, required this.price, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.img, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0);
    var curr = box.hasData('currency') ? box.read("currency").toString() : 'SYP';
    var exchange = box.hasData('exchange') ? box.read("exchange") : '1';
    var echange_price = curr == 'USD' ? formatter.format(double.parse(price)/double.parse(exchange)) : formatter.format(double.parse(price));

    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: (){
        Get.toNamed('/ads/one',arguments: {'id':id},preventDuplicates: false);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,5),
              child: Stack(
                  children: [
                    AspectRatio(aspectRatio: 4/3, child: img != '' ? ClipRRect(child:
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${img}',fit: BoxFit.cover, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
                        Center(child: Opacity(opacity: 0.4, child: Image.asset('assets/logo_white.png', width: 70, height: 70))),
                      ],
                    ),borderRadius: BorderRadius.circular(10)) : Image.asset('assets/imgs/no_img.webp')),
                  ]
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                  Row(
                    children: [
                      Text("$echange_price ${curr.tr}", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),maxLines: 1)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AdsMapCard extends StatefulWidget {
  final String id;
  final String owner_id;
  final String phone;
  final String agency;
  final String title;
  final String price;
  final String curr;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String date;
  final String location;
  final String img;
  final dynamic imgs;
  final int is_fav;
  final VoidCallback? onRefresh;
  const AdsMapCard({super.key, required this.id, required this.owner_id, required this.phone, required this.agency, required this.title, required this.price, required this.curr, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.date, required this.location, required this.img, required this.imgs, this.onRefresh, required this.is_fav});

  @override
  State<AdsMapCard> createState() => _AdsMapCardState();
}
class _AdsMapCardState extends State<AdsMapCard> {
  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat.currency(locale: 'en_US', symbol: '',decimalDigits: 0);
    String user_id = box.hasData('user_id') ? box.read('user_id') : '';
    late int isFavSet = widget.is_fav;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: (){
            Get.toNamed('/ads/one',arguments: {'id':widget.id},preventDuplicates: false);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              _buildImageSection(),
              // Info Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price
                    Text("${currency.format(double.parse(widget.price))} ${widget.curr.tr}", style: TextStyle(color: Color(0xFFD32F2F),fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    // Title
                    Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                    const SizedBox(height: 6),
                    // Description
                    Text(
                        "${widget.bedrooms} ${"bedrooms".tr}, ${widget.bathrooms} ${"bathrooms".tr}, ${widget.garages} ${"garages".tr}, ${"size".tr} ${widget.area_m2} m²",
                        style: TextStyle(color: Colors.black, fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    // Location and Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.location, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        Text(widget.date, style: TextStyle(color: Colors.grey[600], fontSize: 13))
                      ],
                    ),
                  ],
                ),
              ),

              // Buttons Section
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  children: [
                    // Call Button
                    Expanded(
                      flex: 4,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if(widget.phone != "0"){
                            var url = 'tel:+${widget.phone}';
                            if (await canLaunchUrl(Uri.parse(url))) {await launchUrl(Uri.parse(url));}
                          }
                        },
                        icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                        label: Text("call".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1f3c5a),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Chat Button
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        onPressed: user_id == widget.owner_id ? null : () {
                          if(box.hasData('auth') && box.read('auth') == '1'){
                            Get.toNamed('/chat',arguments: {'id':widget.id});
                          }else{
                            Get.snackbar('sorry!'.tr, 'settings_txt_24'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                          }
                        },
                        icon: const Icon(Icons.chat_bubble, size: 18),
                        label: Text("chat".tr, style: TextStyle(fontWeight: FontWeight.bold),),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff1f3c5a),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xff1f3c5a)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Favorite
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8),),
                      child: IconButton(
                        icon: Icon(isFavSet == 1 ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,size: 26,color: Colors.redAccent),
                        onPressed: () async{
                          var res = await apiService('/user/properties/set_fav', {'id':widget.id});
                          if(res != null && res['status'] == 1){
                            setState(() {
                              isFavSet = isFavSet == 1 ? 0:1;
                            });
                          }else{
                            Get.snackbar('sorry!'.tr, 'ads_txt_8'.tr, backgroundColor: Colors.redAccent.withOpacity(0.6),icon: Icon(Icons.error,color: Colors.white,), colorText: Colors.white);
                          }
                        },
                        padding: EdgeInsets.zero,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    var total_imgs = widget.img != '' ? widget.imgs.length+1 : widget.imgs.length;
    String main_img = widget.img != '' ? widget.img : (widget.imgs.length != 0 ? widget.imgs[0] : '');
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),),
          child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${main_img}',fit: BoxFit.cover,height: 220,width: double.infinity, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
        ),
        Positioned(bottom: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Icon(Icons.videocam, color: Colors.white, size: 16),
                //SizedBox(width: 8), // Divider space
                //Text("|", style: TextStyle(color: Colors.white54),),
                //SizedBox(width: 8),
                Text("${total_imgs}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(width: 4),
                Icon(Icons.image, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        //const Positioned(top: 10, left: 10, child: Opacity(opacity: 0.8, child: Text("الدلال", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)],),),),),
        Center(child: Padding(padding: const EdgeInsets.only(top: 20), child: Opacity(opacity: 0.5, child: Image.asset('assets/logo_white.png', width: 120, height: 120)),))
      ],
    );
  }
}
/*
class AdsMapCard extends StatelessWidget {
  final String id;
  final String agency;
  final String title;
  final String price;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String img;
  const AdsMapCard({super.key, required this.id, required this.agency, required this.title, required this.price, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.img});

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0);
    var curr = box.hasData('currency') ? box.read("currency").toString() : 'SYP';
    var exchange = box.hasData('exchange') ? box.read("exchange") : '1';
    var echange_price = curr == 'USD' ? formatter.format(double.parse(price)/double.parse(exchange)) : formatter.format(double.parse(price));

    return Card(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.blueGrey.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {Get.toNamed('/ads/one',arguments: {'id':id},preventDuplicates: false);},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child: AspectRatio(aspectRatio: 4/3, child: img != '' ? ClipRRect(child:
              Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${img}',fit: BoxFit.cover, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
                  Center(child: Opacity(opacity: 0.4, child: Image.asset('assets/logo_white.png', width: 120, height: 120))),
              ],),borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))) : Image.asset('assets/imgs/no_img.webp')),
            ),
            Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  area_m2 != '' ? Chip(
                    label: Row(
                      children: [
                        Icon(FontAwesomeIcons.layerGroup, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text("$area_m2 ${'ads_txt_2'.tr}",style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300)),
                    backgroundColor: Colors.white,
                  ):Container(),
                  SizedBox(width: 5),
                  bedrooms != '' ? Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bed, size: 18, color: Colors.grey[700]),
                        const SizedBox(width: 6),
                        Text(bedrooms, style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300),),
                    backgroundColor: Colors.white,
                  ):Container(),
                  SizedBox(width: 5),
                  bathrooms != '' ? Chip(
                    label: Row(
                      children: [
                        Icon(FontAwesomeIcons.shower, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(bathrooms,style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300)),
                    backgroundColor: Colors.white,
                  ):Container(),
                  SizedBox(width: 5),
                  garages != '' ? Chip(
                    label: Row(
                      children: [
                        Icon(FontAwesomeIcons.warehouse, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(garages,style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade300)),
                    backgroundColor: Colors.white,
                  ):Container(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 19),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                  Row(
                    children: [
                      Text("$echange_price ${curr.tr}", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),maxLines: 1),
                      Spacer(),
                      ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(Color(0xff1f3c5a)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        ),
                        child: Text('التفاصيل',style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
*/
class AlertCard extends StatefulWidget {
  final String id;
  final String title;
  final dynamic search_json;
  final int notification_email;
  final int notification_app;
  final VoidCallback? onRefresh;
  const AlertCard({super.key, required this.id, required this.title, required this.search_json, required this.notification_email, required this.notification_app,required this.onRefresh});

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  final TextEditingController _titleController = TextEditingController();
  int _notificationApp = 0;
  int _notificationEmail = 0;

  Widget PillButton(String text) {
    return text != '' ? Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20),),
        child: Text(text.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87,),),
      ),
    ):Container();
  }

  void showAlertDialog() {
    setState(() {
      _titleController.text = widget.title;
      _notificationApp = widget.notification_app;
      _notificationEmail = widget.notification_email;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('edit'.tr),
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
                    var res = await apiService('/user/alerts/edit', {
                      'id':widget.id,
                      'title':_titleController.text,
                      'notification_app': _notificationApp,
                      'notification_email': _notificationEmail,
                    });
                    if (res != null && res['status'] == 1) {
                      Get.snackbar('success'.tr, 'settings_txt_18'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
                    }
                    widget.onRefresh?.call();
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

  void removeDialog(){
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(15,20,15,10),
        actionsPadding: const EdgeInsets.fromLTRB(10,10,10,10),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,size: 40,color: Colors.black,),
        backgroundColor: Colors.white,
        title: Text('home_txt_11'.tr),
        content: Text('home_txt_12'.tr),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async{
              var res = await apiService('/user/alerts/remove', {'id':widget.id,});
              if (res != null && res['status'] == 1) {
                Get.snackbar('success'.tr, 'settings_txt_25'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
              }
              widget.onRefresh?.call();
              Navigator.of(context).pop();
            },
            child: Text("remove".tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                PillButton("${widget.search_json['purpose']}"),
                PillButton("${widget.search_json['type']}"),
                PillButton("${widget.search_json['is_furnished']}"),
                PillButton("${widget.search_json['state']}"),
                PillButton("${widget.search_json['city']}"),
              ],
            ),
            //const SizedBox(height: 20.0),
            //const Text('Alerts: None', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 28),
                      onPressed: removeDialog,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, size: 28),
                      onPressed: () {
                        showAlertDialog();
                      },
                    ),
                  ],
                ),

                // Search Button
                SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed('/ads/ads',arguments: {'id':widget.id},preventDuplicates: false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xff1f3c5a),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xff1f3c5a), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text('search'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class AdsCardSmallEdit extends StatefulWidget {
  final String id;
  final String owner_id;
  final String phone;
  final String agency;
  final String title;
  final String price;
  final String curr;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String date;
  final String location;
  final String img;
  final dynamic imgs;
  final VoidCallback? onRefresh;
  const AdsCardSmallEdit({super.key, required this.id, required this.owner_id, required this.phone, required this.agency, required this.title, required this.price, required this.curr, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.date, required this.location, required this.img, required this.imgs, this.onRefresh});

  @override
  State<AdsCardSmallEdit> createState() => _AdsCardSmallEditState();
}
class _AdsCardSmallEditState extends State<AdsCardSmallEdit> {

  void Delete(){
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(15,20,15,10),
        actionsPadding: const EdgeInsets.fromLTRB(10,10,10,10),
        icon: const Icon(FontAwesomeIcons.triangleExclamation,size: 40,color: Colors.black,),
        backgroundColor: Colors.white,
        title: Text('global_txt_67'.tr),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async{
              var res = await apiService('/agency/properties/remove', {'id':widget.id});
              if(res != null && res['status'] == 1){
                box.write('service_refresh','1');
                Get.back();
                Get.back();
                Get.snackbar('success'.tr, 'global_txt_64'.tr, backgroundColor: Colors.green.withOpacity(0.6),icon: Icon(Icons.check,color: Colors.white,), colorText: Colors.white);
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
    var currency = NumberFormat.currency(locale: 'en_US', symbol: '',decimalDigits: 0);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: (){
            Get.toNamed('/ads/one',arguments: {'id':widget.id},preventDuplicates: false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2),),],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                _buildImageSection(),
                // Info Section
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text("${currency.format(double.parse(widget.price))} ${widget.curr.tr}", style: TextStyle(color: Color(0xFFD32F2F),fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 3),
                      // Title
                      Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),maxLines: 1,overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      // Description
                      Text(
                          "${widget.bedrooms} ${"bedrooms".tr}, ${widget.bathrooms} ${"bathrooms".tr}, ${widget.garages} ${"garages".tr}, ${"size".tr} ${widget.area_m2} m²",
                          style: TextStyle(color: Colors.black, fontSize: 12, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      // Location and Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.location, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          //Text(widget.date, style: TextStyle(color: Colors.grey[600], fontSize: 13))
                        ],
                      ),
                    ],
                  ),
                ),

                Spacer(),
                // Buttons Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 3),
                  child: Row(
                    children: [
                      // Call Button
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            Get.toNamed('/agency/add_ads',arguments: {'id':widget.id},preventDuplicates: false);
                          },
                          icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1f3c5a),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat Button
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            Delete();
                          },
                          icon: const Icon(Icons.delete, size: 18),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            side: BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    var total_imgs = widget.img != '' ? widget.imgs.length : widget.imgs.length;
    String main_img = widget.img != '' ? widget.img : (widget.imgs.length != 0 ? widget.imgs[0] : '');
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),),
          child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${main_img}',fit: BoxFit.cover,height: 140,width: double.infinity, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
        ),
        Positioned(bottom: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Icon(Icons.videocam, color: Colors.white, size: 16),
                //SizedBox(width: 8), // Divider space
                //Text("|", style: TextStyle(color: Colors.white54),),
                //SizedBox(width: 8),
                Text("${total_imgs}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(width: 4),
                Icon(Icons.image, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        //const Positioned(top: 10, left: 10, child: Opacity(opacity: 0.8, child: Text("الدلال", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)],),),),),
        Center(child: Padding(padding: const EdgeInsets.only(top: 40), child: Opacity(opacity: 0.5, child: Image.asset('assets/logo_white.png', width: 60, height: 60)),))
      ],
    );
  }
}



class AgencyCard extends StatelessWidget {
  final String id;
  final String name;
  final String img;
  const AgencyCard({super.key, required this.id, required this.name, required this.img});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: (){
        Get.toNamed('/ads/agency',arguments: {'id':id});
      },
      child: Container(
        //color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(3,0,3,8),
              child: AspectRatio(
                  aspectRatio: 1/1,
                  child: img != '' ? ClipRRect(child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/sm/${img}',fit: BoxFit.cover, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Padding(padding: const EdgeInsets.all(8.0), child: Image.asset('assets/imgs/types/office.png'),)),borderRadius: BorderRadius.circular(15)) : Padding(padding: const EdgeInsets.all(8.0), child: Image.asset('assets/imgs/types/office.png'))),
            ),
            Text(name, style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}


class VPlayer extends StatefulWidget {
  final String videoUrl;
  const VPlayer({super.key, required this.videoUrl});

  @override
  State<VPlayer> createState() => _VPlayerState();
}
class _VPlayerState extends State<VPlayer> {
  late VideoPlayerController _controller;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..addListener(() {if (_controller.value.hasError) {setState(() => _isLoading = false);}})
      ..initialize().then((_) => setState(() => _isLoading = false)).catchError((error) {setState(() => _isLoading = false);});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading ? Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(child: VideoPlayer(_controller),borderRadius: BorderRadius.circular(12)),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 0),
            child: VideoProgressIndicator(_controller, allowScrubbing: true)
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ],
    ): const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 2,),
      ),
    );
  }
}





