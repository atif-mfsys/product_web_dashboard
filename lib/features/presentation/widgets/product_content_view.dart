import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_web_dashboard/core/utils/product_data_table.dart';
import 'package:products_web_dashboard/core/utils/product_grid.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';
import 'package:products_web_dashboard/main.dart';


class ProductContentView extends StatelessWidget {
  const ProductContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is ProductLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isMedium = constraints.maxWidth > 600;

              if (isWide) {
                return ProductDataTable(products: state.filtered);
              } else if (isMedium) {
                return ProductGrid(products: state.filtered, crossAxis: 2);
              } else {
                return ProductGrid(products: state.filtered, crossAxis: 1);
              }
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
