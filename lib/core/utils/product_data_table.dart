 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';
import 'package:products_web_dashboard/features/presentation/widgets/add_delete_dialog.dart';
import 'package:products_web_dashboard/main.dart';

class ProductDataTable extends StatelessWidget {
  final List<Product> products;
  const ProductDataTable({required this.products, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            WidgetStateProperty.all(Colors.green.shade600), // Header background
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.green.withOpacity(0.1);
            }
            return null;
          },
        ),
        columnSpacing: 24,
        dataRowHeight: 56,
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List<DataRow>.generate(
          products.length,
          (index) {
            final p = products[index];
            return DataRow(
              color: WidgetStateProperty.all(
                index.isEven ? Colors.grey.shade100 : Colors.white,
              ),
              cells: [
                DataCell(Text(p.id),
                    onTap: () => context.go('/product/${p.id}')),
                DataCell(Text(p.title),
                    onTap: () => context.go('/product/${p.id}')),
                DataCell(Text(p.category)),
                DataCell(Text('\$${p.price.toStringAsFixed(2)}')),
                DataCell(
                  Text(
                    p.inStock ? 'In stock' : 'Out',
                    style: TextStyle(
                      color: p.inStock ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AddEditProductDialog(existing: p),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ProductCubit>().deleteProduct(p.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}