import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../services/api_service.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('test'.tr),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: [

              SizedBox(height: 10),


            ],
          ),
        ),
      ),
    );
  }
}


class AdsCard extends StatelessWidget {
  final String id;
  final String agency;
  final String title;
  final String price;
  final String area_m2;
  final String bedrooms;
  final String bathrooms;
  final String garages;
  final String date;
  final String location;
  final String img;
  final VoidCallback? onRefresh;
  const AdsCard({super.key, required this.id, required this.agency, required this.title, required this.price, required this.area_m2, required this.bedrooms, required this.bathrooms, required this.garages, required this.date, required this.location, required this.img, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: (){
        Get.toNamed('/ads/one',arguments: {'id':id},preventDuplicates: false);
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
                  Text("${price}", style: TextStyle(color: Color(0xFFD32F2F),fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  // Title
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    "${bedrooms} ${"bedrooms".tr}, ${bathrooms} ${"bathrooms".tr}, ${garages} ${"garages".tr}, ${"size".tr} ${area_m2} m²",
                    style: TextStyle(color: Colors.black, fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  // Location and Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(location, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 13))
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
                    flex: 5,
                    child: ElevatedButton.icon(
                      onPressed: () {},
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
                      onPressed: () {},
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
                      icon: const Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {},
                      padding: EdgeInsets.zero,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),),
          child: CachedNetworkImage(imageUrl: '${API_URL}/uploads/imgs/md/${img}',fit: BoxFit.cover,height: 220,width: double.infinity, placeholder: (context, url) => Center(child: Container(width: 28,height: 28,child: const CircularProgressIndicator(color: Colors.black,strokeWidth: 2))), errorWidget: (context, url, error) => Image.asset('assets/imgs/no_img.webp')),
        ),
        Positioned(bottom: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                //Icon(Icons.videocam, color: Colors.white, size: 16),
                //SizedBox(width: 8), // Divider space
                //Text("|", style: TextStyle(color: Colors.white54),),
                //SizedBox(width: 8),
                Text("8", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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