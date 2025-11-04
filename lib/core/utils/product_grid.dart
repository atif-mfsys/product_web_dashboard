
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';
import 'package:products_web_dashboard/features/presentation/widgets/add_delete_dialog.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final int crossAxis;
  const ProductGrid({required this.products, required this.crossAxis, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxis, childAspectRatio: 3),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => context.go('/product/${p.id}'),
            title: Text(p.title),
            subtitle: Text('${p.category} • \$${p.price.toStringAsFixed(2)}'),
            trailing: Wrap(spacing: 8, children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AddEditProductDialog(existing: p))),
              IconButton(
                  icon: Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: () =>
                      context.read<ProductCubit>().deleteProduct(p.id)),
            ]),
          ),
        );
      },
    );
  }
}