import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_web_dashboard/core/routes/routes.dart';
import 'package:products_web_dashboard/features/presentation/blocs/products_cubit.dart';
import 'package:products_web_dashboard/features/data/products_repository.dart';

import 'package:products_web_dashboard/features/presentation/blocs/theme_cubit.dart';

void main() {
  final repo = ProductRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ProductCubit(repo)..load()),
      ],
      child: const ProductDashboardApp(),
    ),
  );
}
