import 'package:flutter/material.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/main_tab_page.dart';
import '../features/product/presentation/product_list_page.dart';
import '../features/product/presentation/product_detail_page.dart';
import '../features/cart/presentation/cart_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../shared/presentation/not_found_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String productList = '/products';
  static const String productDetail = '/product_detail';
  static const String cart = '/cart';
  static const String profile = '/profile';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const MainTabPage(),
          settings: settings,
        );
      case AppRoutes.productList:
        return MaterialPageRoute(
          builder: (_) => const ProductListPage(),
          settings: settings,
        );
      case AppRoutes.productDetail:
        final args = settings.arguments;
        final productId = args is String ? args : null;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(productId: productId),
          settings: settings,
        );
      case AppRoutes.cart:
        return MaterialPageRoute(
          builder: (_) => const CartPage(),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
          settings: settings,
        );
    }
  }
}

