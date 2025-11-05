import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideBar extends StatelessWidget {
  final String currentRoute;
  const SideBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/'},
      {'title': 'Products', 'icon': Icons.inventory_2, 'route': '/'},
      {'title': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
    ];

    return Container(
      width: 240,
      color: Colors.green[700],
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text('Product Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 30),
          ...menuItems.map((item) {
            final selected = currentRoute == item['route'];
            return ListTile(
              leading: Icon(item['icon'] as IconData,
                  color: selected ? Colors.white : Colors.white70),
              title: Text(item['title'] as String,
                  style: TextStyle(
                      color: selected ? Colors.white : Colors.white70)),
              selected: selected,
              onTap: () => context.go(item['route'] as String),
            );
          }),
        ],
      ),
    );
  }
}
