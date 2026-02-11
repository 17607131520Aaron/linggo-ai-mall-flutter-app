import 'package:linggo_ai_mall_app/features/cart/domain/entities/cart_item.dart';

class CartShop {
  CartShop({
    required this.shopName,
    required this.items,
  });

  final String shopName;
  final List<CartItem> items;
}

