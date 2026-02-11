import 'package:flutter/material.dart';

import '../../../router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linggo 商城'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '欢迎来到 Linggo AI Mall',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '这是应用的首页，你可以从这里进入商品列表、购物车和个人中心等功能。',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _HomeEntryButton(
                  icon: Icons.storefront,
                  label: '商品列表',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.productList),
                ),
                _HomeEntryButton(
                  icon: Icons.shopping_cart,
                  label: '购物车',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                ),
                _HomeEntryButton(
                  icon: Icons.person,
                  label: '个人中心',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeEntryButton extends StatelessWidget {
  const _HomeEntryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

