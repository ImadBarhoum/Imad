import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

StreamSubscription? _linkSubscription;
bool _initialLinkHandled = false;
Future<String?> getInitialLinkRoute() async {
  final appLinks = AppLinks();
  try {
    final uri = await appLinks.getInitialLink();
    if (uri != null) {
      _initialLinkHandled = true;
      return _getTargetRouteFromUri(uri);
    }
  } catch (e) {
    print('DeepLink Error: getInitialLink(): $e');
  }
  return null;
}

void initDeepLinkListener() {
  final appLinks = AppLinks();
  _linkSubscription?.cancel();
  _linkSubscription = appLinks.uriLinkStream.listen((uri) {
    if (_initialLinkHandled) {
      _initialLinkHandled = false;
      return;
    }
    final route = _getTargetRouteFromUri(uri);
    if (route != null) {
      Get.toNamed(route);
    }
  });
}

void disposeDeepLinkListener() {
  _linkSubscription?.cancel();
}

String? _getTargetRouteFromUri(Uri uri) {
  if (uri.pathSegments.isNotEmpty) {
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'link') {
      final id = uri.pathSegments[1];
      print('DeepLink: Parsed route to: /ads/one/$id');
      return '/ads/one/$id';
    }
  }
  return null;
}

