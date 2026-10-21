import 'package:get/get.dart';
// Home
import 'views/home/layout.dart';
import 'views/home/alerts.dart';
import 'views/chats/chats.dart';
import 'views/chats/chat.dart';
// Ads
import 'views/ads/ads.dart';
import 'views/ads/one.dart';
import 'views/agency/add.dart';
import 'views/ads/agency.dart';
// Agency
import 'views/agency/profile.dart';
import 'views/agency/recent_view.dart';
import 'views/home/fav.dart';
import 'views/agency/my_ads.dart';
import 'views/agency/agency_search.dart';
// Settings
import 'views/settings/profile.dart';
import 'views/settings/verify.dart';
// Others
import 'views/others/about.dart';
import 'views/others/privacy.dart';
import 'views/others/terms.dart';
import 'views/others/maintenance.dart';
import 'views/others/offline.dart';
import 'views/others/version.dart';
import 'views/others/introduction.dart';
// Auth
import 'views/auth/login.dart';
import 'views/auth/login_with_wp.dart';
import 'views/auth/register.dart';
import 'views/auth/reset.dart';
import 'package:app/widgets/test.dart';


class AppPages {
  static final routes = [
    GetPage(name: '/test', page: () => TestPage()),

    // Home
    GetPage(name: '/home', page: () => HomeLayout()), // done
    GetPage(name: '/chats', page: () => ChatsPage()), // done
    GetPage(name: '/chat', page: () => ChatPage()), // done
    GetPage(name: '/alerts', page: () => AlertsPage()), // working
    GetPage(name: '/fav', page: () => FavoritesPage()), // done

    // Ads
    GetPage(name: '/ads/ads', page: () => AdsPage()), // done
    GetPage(name: '/ads/one', page: () => AdsOnePage()), // done
    GetPage(name: '/ads/one/:id', page: () => AdsOnePage()), // done
    GetPage(name: '/ads/agency', page: () => AgencyPage()), // done
    GetPage(name: '/ads/agency/:id', page: () => AgencyPage()), // done

    // Agency
    GetPage(name: '/agency/my_ads', page: () => AgencyAdsPage()), //
    GetPage(name: '/agency/add_ads', page: () => AddAdsPage()), //
    GetPage(name: '/agency/profile', page: () => AgencyProfilePage()), //
    GetPage(name: '/recent_view', page: () => RecentViewPage()), // done
    GetPage(name: '/agency/search', page: () => AgencySearchPage()), // done

    // Settings
    GetPage(name: '/settings/profile', page: () => ProfilePage()), // done
    GetPage(name: '/settings/verify', page: () => VerfiryPage()), // done

    // Others
    GetPage(name: '/others/maintenance', page: () => Maintenance()), // done
    GetPage(name: '/others/offline', page: () => Offline()), // done
    GetPage(name: '/others/version', page: () => Version()), // done
    GetPage(name: '/others/terms', page: () => TermsPage()), // done
    GetPage(name: '/others/privacy', page: () => PrivacyPage()), // done
    GetPage(name: '/others/about', page: () => AboutPage()), // done
    GetPage(name: '/introduction', page: () => OnboardingScreen()), // done

    // Auth
    GetPage(name: '/auth/login', page: () => LoginPage()), // done
    GetPage(name: '/auth/login_with_wp', page: () => LoginWithWp()), // done
    GetPage(name: '/auth/register', page: () => RegisterPage()), // done
    GetPage(name: '/auth/reset', page: () => ResetPage()), // done




  ];
}
