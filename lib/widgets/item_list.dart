import 'package:flutter/material.dart';

class ItemList<T> extends StatelessWidget {
  const ItemList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.empty,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 96),
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget empty;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return empty;
    }

    return ListView.separated(
      padding: padding,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
