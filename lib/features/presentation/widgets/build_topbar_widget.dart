import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';

class ProductTopBar extends StatefulWidget {
  const ProductTopBar({super.key});

  @override
  State<ProductTopBar> createState() => _ProductTopBarState();
}

class _ProductTopBarState extends State<ProductTopBar> {
  final TextEditingController _searchCtr = TextEditingController();

  @override
  void dispose() {
    _searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is! ProductLoaded) return const SizedBox();

        final categories = [
          'All',
          ...{for (var p in state.products) p.category}
        ];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtr,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search products...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.2),
                    ),
                  ),
                  onChanged: (v) => context.read<ProductCubit>().search(v),
                ),
              ),
              const SizedBox(width: 16),

              _buildDropdown<String>(
                value: state.categoryFilter,
                items: categories,
                onChanged: (v) =>
                    context.read<ProductCubit>().filterByCategory(v ?? 'All'),
                icon: Icons.category,
              ),
              const SizedBox(width: 16),

              _buildDropdown<String>(
                value: state.inStockFilter == null
                    ? 'All'
                    : (state.inStockFilter! ? 'In stock' : 'Out'),
                items: const ['All', 'In stock', 'Out'],
                onChanged: (v) => context
                    .read<ProductCubit>()
                    .filterByStock(v == 'All' ? null : (v == 'In stock')),
                icon: Icons.inventory_2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),
          DropdownButton<T>(
            value: value,
            underline: const SizedBox(),
            items: items
                .map((e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(e.toString(),
                          style: const TextStyle(fontSize: 14)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
