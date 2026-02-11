import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '未登录用户',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '点击登录后可同步购物车和订单信息',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.receipt_long),
                    title: Text('我的订单'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('我的收藏'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('设置'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

