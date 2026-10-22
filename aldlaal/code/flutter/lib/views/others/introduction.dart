import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/services/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _data = [
    {
      "title": "home_txt_15",
      "desc": "home_txt_16",
      "icon": FontAwesomeIcons.city
    },
    {
      "title": "home_txt_17",
      "desc": "home_txt_18",
      "icon": FontAwesomeIcons.buildingFlag
    },
    {
      "title": "home_txt_19",
      "desc": "home_txt_20",
      "icon": FontAwesomeIcons.comments
    },
    {
      "title": "home_txt_21",
      "desc": "home_txt_22",
      "icon": FontAwesomeIcons.handshake
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _data.length,
              itemBuilder: (context, index) => OnboardingContent(
                title: _data[index]['title']!,
                desc: _data[index]['desc']!,
                icon: _data[index]['icon']!,
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _data.length,
                          (index) => buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _data.length - 1) {
                          box.write('skip_first_time_screen', '1');
                          Get.offAllNamed('/home');
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1f3c5a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        _currentPage == _data.length - 1 ? "start_now".tr : "next".tr,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
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
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Color(0xff1f3c5a).withOpacity(0.7) : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title, desc;
  final IconData icon;
  const OnboardingContent({required this.title, required this.desc, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(width: 190,child: Icon(icon, size: 150, color: Color(0xff1f3c5a).withOpacity(0.9))),
          const SizedBox(height: 40),
          Text(
            title.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Text(
            desc.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 40),
          const Spacer(),
        ],
      ),
    );
  }
}