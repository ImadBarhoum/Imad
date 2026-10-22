import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/firebase_options.dart';
import 'langs/local.dart';
import 'services/api_service.dart';
import 'router.dart';
import 'services/firebase_api.dart';
import 'services/deeplink.dart' as deepLinkService;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(name:'default',options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();

  deepLinkService.initDeepLinkListener();
  String? deepLinkRoute = await deepLinkService.getInitialLinkRoute();
  String firstRoute;
  if (deepLinkRoute != null) {
    firstRoute = deepLinkRoute;
  } else {
    firstRoute = await getFirstRoute();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp(firstRoute));
  });
}

class MyApp extends StatelessWidget {
  MyApp(this.firstRoute);
  final String firstRoute;
  final LocaleController localeController = Get.put(LocaleController());

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: firstRoute,
        getPages: AppPages.routes,
        textDirection: localeController.textDirection,
        locale: localeController.locale.value ?? Locale('ar'),
        translations: appTranslations(),
        fallbackLocale: Locale('ar'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ar'),
          const Locale('en'),
        ],
        theme: ThemeData(
          fontFamily: 'Ar',
        ),
      );
    });
  }
}