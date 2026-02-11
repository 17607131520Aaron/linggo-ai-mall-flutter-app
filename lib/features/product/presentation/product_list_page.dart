import 'package:flutter/material.dart';

import '../../../router/app_router.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 这里先使用假数据，后续可以替换为真实接口数据
    final products = List.generate(
      10,
      (index) => 'AI 商品 #${index + 1}',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品列表'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final name = products[index];
          final price = (index + 1) * 9.9;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(name),
              subtitle: Text('¥${price.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.productDetail,
                  arguments: 'product_${index + 1}',
                );
              },
            ),
          );
        },
      ),
    );
  }
}

