import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'ar.dart';
import 'en.dart';

class appTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': Arabic,
    'en': English,
  };
}

class LocaleController extends GetxController {
  final box = GetStorage();
  final locale = Rxn<Locale>();
  final isRTL = true.obs;

  @override
  void onInit() {
    super.onInit();
    final savedLocale = box.read('lang') ?? 'ar';
    updateLocale(savedLocale);
  }
  void updateLocale(String languageCode) {
    locale.value = Locale(languageCode);
    isRTL.value = languageCode == 'ar';
    box.write('lang', languageCode);
    Get.updateLocale(locale.value!);
  }
  TextDirection get textDirection => isRTL.value ? TextDirection.rtl : TextDirection.ltr;
}