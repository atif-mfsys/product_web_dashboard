import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';
import 'package:products_web_dashboard/features/presentation/widgets/add_delete_dialog.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  const ProductDetailsPage({required this.productId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
          if (state is ProductLoaded) {
            final product = state.products.firstWhere((p) => p.id == productId,
                orElse: () => Product(
                    id: productId,
                    title: 'Not found',
                    category: '-',
                    price: 0,
                    stock: 0));
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 8),
                  Text('Category: ${product.category}'),
                  SizedBox(height: 4),
                  Text('Price: \$${product.price.toStringAsFixed(2)}'),
                  SizedBox(height: 4),
                  Text('Stock: ${product.stock}'),
                  SizedBox(height: 12),
                  Row(children: [
                    ElevatedButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (_) =>
                                AddEditProductDialog(existing: product)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, 
                          foregroundColor: Colors.white, 
                        ),
                        child: Text('Edit')),
                    SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          context
                              .read<ProductCubit>()
                              .deleteProduct(product.id);
                          context.go('/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, 
                          foregroundColor: Colors.white, 
                        ),
                        child: Text('Delete')),
                  ])
                ]);
          }
          if (state is ProductLoading)
            return Center(child: CircularProgressIndicator());
          return Center(child: Text('Loading...'));
        }),
      ),
    );
  }
}
