import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';
import 'package:products_web_dashboard/features/presentation/blocs/theme_cubit.dart';
import 'package:products_web_dashboard/features/presentation/widgets/add_delete_dialog.dart';
import 'package:products_web_dashboard/features/presentation/widgets/build_topbar_widget.dart';
import 'package:products_web_dashboard/features/presentation/widgets/product_content_view.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({Key? key}) : super(key: key);

  final TextEditingController _searchCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ProductTopBar(),
          SizedBox(height: 12),
          Expanded(child: ProductContentView()),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.green,
        backgroundColor: Colors.green,
        onPressed: () => _openAddEditModal(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString(),
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  void _openAddEditModal(BuildContext context, {Product? product}) {
    showDialog(
        context: context,
        builder: (_) => AddEditProductDialog(existing: product));
  }
}
