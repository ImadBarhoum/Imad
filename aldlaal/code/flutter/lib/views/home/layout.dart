import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/services/controller.dart';
import 'home.dart';
import '/views/chats/chats.dart';
import '/views/home/myads.dart';
import '/views/settings/layout.dart';
GetStorage box = GetStorage();

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late String auth = box.hasData('auth') ? box.read('auth') : '0';
  late var barIdx = 0;
  static const List pages = [
    HomePage(),
    ChatsPage(),
    MyAdsPage(),
    SettingsLayout(),
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 77,
          title: GestureDetector(
              onTap: (){if (Get.isRegistered<HomeController>()) {Get.find<HomeController>().scrollToTop();}},
              child: Image.asset('assets/logo_white.png',height: 50)
          ),
          centerTitle: true,
          backgroundColor: Color(0xff1f3c5a),
          //surfaceTintColor: Color(0xff1f3c5a),
          //shadowColor: Colors.blueGrey.withOpacity(0.2),
          elevation: 0,
          actions: [],
        ),
        body: pages.elementAt(barIdx),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 10,
          highlightElevation: 20.0,
          onPressed: (){
            if(auth == '1'){
              Get.toNamed('/agency/add_ads');
            }else{
              Get.toNamed('/auth/login');
            }
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1,color: Colors.white),
            borderRadius: BorderRadiusGeometry.circular(100),
          ),
          child: Icon(Icons.add,color: Colors.orange,size: 40),
        ),
        bottomNavigationBar: NavigationBarTheme(
            data:NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                    (Set<MaterialState> states) => states.contains(MaterialState.selected)
                    ? const TextStyle(color: Colors.amberAccent,fontSize: 13) : const TextStyle(color: Colors.white,fontSize: 11),
              ),
            ),
            child: NavigationBar(
              indicatorColor: Colors.transparent,
              shadowColor: Colors.blueGrey,
              surfaceTintColor: Color(0xff1f3c5a),
              elevation: 30,
              backgroundColor: Color(0xff1f3c5a),
              selectedIndex: barIdx,
              onDestinationSelected: (idx){
                setState(() {barIdx = idx;});
                if (barIdx == 0 && Get.isRegistered<HomeController>()) {Get.find<HomeController>().scrollToTop();}
              },
              destinations: [
                NavigationDestination(label: 'home'.tr, icon: Icon(FontAwesomeIcons.home,color: barIdx == 0 ? Colors.amberAccent : Colors.white)),
                NavigationDestination(label: 'chats'.tr, icon: Icon(FontAwesomeIcons.solidComment,color: barIdx == 1 ? Colors.amberAccent : Colors.white)),
                NavigationDestination(label: 'ads_txt_9'.tr, icon: Icon(FontAwesomeIcons.sheetPlastic,color: barIdx == 2 ? Colors.amberAccent : Colors.white)),
                NavigationDestination(label: 'account'.tr, icon: Icon(FontAwesomeIcons.solidUser,color: barIdx == 3 ? Colors.amberAccent : Colors.white)),
              ],
            )
        ),
      ),
    );
  }
}