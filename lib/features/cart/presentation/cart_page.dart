import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _editMode = false;
  bool _selectAll = false;

  // 淘宝购物车常见：按店铺分组
  final List<_CartShop> _shops = [
    _CartShop(
      shopName: 'Linggo 官方旗舰店',
      items: [
        _CartItem(
          title: '无线蓝牙耳机 入耳式降噪',
          sku: '黑色｜标准版',
          price: 129,
          originPrice: 199,
          count: 1,
        ),
        _CartItem(
          title: '智能手表 运动防水手环',
          sku: '银色｜NFC',
          price: 239,
          originPrice: 299,
          count: 2,
        ),
      ],
    ),
    _CartShop(
      shopName: '精选生活馆',
      items: [
        _CartItem(
          title: '时尚连衣裙 夏季新款 修身显瘦',
          sku: 'S｜粉色',
          price: 199,
          originPrice: 269,
          count: 1,
        ),
        _CartItem(
          title: '运动鞋男透气跑步鞋 轻便耐磨',
          sku: '42｜白黑',
          price: 259,
          originPrice: 329,
          count: 1,
        ),
        _CartItem(
          title: '时尚女包 单肩包斜挎包',
          sku: '米白｜小号',
          price: 159,
          originPrice: 239,
          count: 1,
        ),
      ],
    ),
  ];

  bool get _hasAnySelected {
    for (final s in _shops) {
      for (final i in s.items) {
        if (i.selected) return true;
      }
    }
    return false;
  }

  int get _selectedCount {
    var n = 0;
    for (final s in _shops) {
      for (final i in s.items) {
        if (i.selected) n++;
      }
    }
    return n;
  }

  int get _totalPrice {
    var total = 0;
    for (final s in _shops) {
      for (final i in s.items) {
        if (i.selected) total += i.price * i.count;
      }
    }
    return total;
  }

  void _recalcSelectAll() {
    if (_shops.isEmpty) {
      _selectAll = false;
      return;
    }
    for (final s in _shops) {
      for (final i in s.items) {
        if (!i.selected) {
          _selectAll = false;
          return;
        }
      }
    }
    _selectAll = true;
  }

  void _setAllSelected(bool value) {
    for (final s in _shops) {
      for (final i in s.items) {
        i.selected = value;
      }
    }
    _selectAll = value;
  }

  void _setShopSelected(_CartShop shop, bool value) {
    for (final i in shop.items) {
      i.selected = value;
    }
    _recalcSelectAll();
  }

  bool _isShopAllSelected(_CartShop shop) {
    if (shop.items.isEmpty) return false;
    return shop.items.every((e) => e.selected);
  }

  void _deleteSelected() {
    for (final s in _shops) {
      s.items.removeWhere((e) => e.selected);
    }
    _shops.removeWhere((s) => s.items.isEmpty);
    _recalcSelectAll();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('购物车'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _editMode = !_editMode;
              });
            },
            child: Text(
              _editMode ? '完成' : '编辑',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
      body: _shops.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text('你的购物车还是空的~', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    '去逛逛商品，把喜欢的都加进来吧。',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 92),
              itemCount: _shops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, shopIndex) {
                final shop = _shops[shopIndex];
                return _ShopCard(
                  shop: shop,
                  shopAllSelected: _isShopAllSelected(shop),
                  editMode: _editMode,
                  onShopToggle: (v) {
                    setState(() {
                      _setShopSelected(shop, v);
                    });
                  },
                  onItemToggle: (item, v) {
                    setState(() {
                      item.selected = v;
                      _recalcSelectAll();
                    });
                  },
                  onItemCountChanged: (item, next) {
                    setState(() {
                      item.count = next;
                    });
                  },
                  onItemDeleted: (item) {
                    setState(() {
                      shop.items.remove(item);
                      if (shop.items.isEmpty) _shops.remove(shop);
                      _recalcSelectAll();
                    });
                  },
                );
              },
            ),
      bottomNavigationBar: _shops.isEmpty
          ? null
          : _CartBottomBar(
              editMode: _editMode,
              selectAll: _selectAll,
              selectedCount: _selectedCount,
              totalPrice: _totalPrice,
              hasAnySelected: _hasAnySelected,
              onToggleAll: (v) {
                setState(() {
                  _setAllSelected(v);
                });
              },
              onPrimaryAction: () {
                if (!_hasAnySelected) return;
                if (_editMode) {
                  setState(() {
                    _deleteSelected();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已删除选中商品（示例）')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('结算 $_selectedCount 件，共 ¥$_totalPrice（示例）')),
                  );
                }
              },
            ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.shop,
    required this.shopAllSelected,
    required this.editMode,
    required this.onShopToggle,
    required this.onItemToggle,
    required this.onItemCountChanged,
    required this.onItemDeleted,
  });

  final _CartShop shop;
  final bool shopAllSelected;
  final bool editMode;
  final ValueChanged<bool> onShopToggle;
  final void Function(_CartItem item, bool selected) onItemToggle;
  final void Function(_CartItem item, int nextCount) onItemCountChanged;
  final ValueChanged<_CartItem> onItemDeleted;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _TaobaoCheckbox(
                  value: shopAllSelected,
                  onChanged: onShopToggle,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.storefront_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    shop.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
            const SizedBox(height: 10),
            ...shop.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: _CartItemRow(
                  item: item,
                  editMode: editMode,
                  onToggle: (v) => onItemToggle(item, v),
                  onCountChanged: (n) => onItemCountChanged(item, n),
                  onDeleted: () => onItemDeleted(item),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.editMode,
    required this.onToggle,
    required this.onCountChanged,
    required this.onDeleted,
  });

  final _CartItem item;
  final bool editMode;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onCountChanged;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '删除',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      confirmDismiss: (_) async {
        // 淘宝常见：滑动删除直接删，这里不弹窗
        return true;
      },
      onDismissed: (_) => onDeleted(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaobaoCheckbox(
            value: item.selected,
            onChanged: onToggle,
          ),
          const SizedBox(width: 8),
          // 图片占位
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 86,
              height: 86,
              color: const Color(0xFFEFEFEF),
              child: const Center(
                child: Text('图片', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          item.sku,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black45),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '¥${item.price}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '¥${item.originPrice}',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    _CountStepper(
                      value: item.count,
                      onChanged: onCountChanged,
                      dense: true,
                    ),
                  ],
                ),
                if (editMode) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '移入收藏',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '更多',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.more_horiz, size: 18, color: Colors.black45),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({
    required this.editMode,
    required this.selectAll,
    required this.selectedCount,
    required this.totalPrice,
    required this.hasAnySelected,
    required this.onToggleAll,
    required this.onPrimaryAction,
  });

  final bool editMode;
  final bool selectAll;
  final int selectedCount;
  final int totalPrice;
  final bool hasAnySelected;
  final ValueChanged<bool> onToggleAll;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            _TaobaoCheckbox(
              value: selectAll,
              onChanged: onToggleAll,
            ),
            const SizedBox(width: 4),
            const Text('全选', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 10),
            if (!editMode) ...[
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '合计: ',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        '¥$totalPrice',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '不含运费｜优惠在结算页计算',
                    style: TextStyle(fontSize: 10, color: Colors.black38),
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ] else ...[
              const Spacer(),
            ],
            SizedBox(
              height: 40,
              child: FilledButton(
                onPressed: hasAnySelected ? onPrimaryAction : null,
                style: FilledButton.styleFrom(
                  backgroundColor: editMode ? Colors.redAccent : Colors.deepOrangeAccent,
                  disabledBackgroundColor: const Color(0xFFDDDDDD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(
                  editMode ? '删除($selectedCount)' : '结算($selectedCount)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountStepper extends StatelessWidget {
  const _CountStepper({
    required this.value,
    required this.onChanged,
    this.dense = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final height = dense ? 28.0 : 32.0;
    final width = dense ? 28.0 : 32.0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            width: width,
            icon: Icons.remove,
            onPressed: value <= 1 ? null : () => onChanged(value - 1),
          ),
          Container(
            width: dense ? 36 : 42,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          _StepButton(
            width: width,
            icon: Icons.add,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.width,
    required this.icon,
    required this.onPressed,
  });

  final double width;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: double.infinity,
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 16,
          color: onPressed == null ? Colors.black26 : Colors.black87,
        ),
      ),
    );
  }
}

class _TaobaoCheckbox extends StatelessWidget {
  const _TaobaoCheckbox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? Colors.redAccent : const Color(0xFFBDBDBD),
            width: 1.5,
          ),
          color: value ? Colors.redAccent : Colors.transparent,
        ),
        child: value
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _CartShop {
  _CartShop({
    required this.shopName,
    required this.items,
  });

  final String shopName;
  final List<_CartItem> items;
}

class _CartItem {
  _CartItem({
    required this.title,
    required this.sku,
    required this.price,
    required this.originPrice,
    required this.count,
    this.selected = false,
  }) : id = UniqueKey().toString();

  final String id;
  final String title;
  final String sku;
  final int price;
  final int originPrice;
  int count;
  bool selected;
}

