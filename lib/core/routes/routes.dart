import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:products_web_dashboard/features/presentation/blocs/theme_cubit.dart';
import 'package:products_web_dashboard/features/presentation/pages/products_details_page.dart';
import 'package:products_web_dashboard/main.dart';
import 'package:products_web_dashboard/settings.dart';
import 'package:products_web_dashboard/theme.dart';

import '../../features/presentation/pages/product_list_page.dart';
import '../utils/responive.dart';

class ProductDashboardApp extends StatelessWidget {
  const ProductDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return ResponsiveLayoutShell(
              currentRoute: state.uri.path,
              child: child,
            );
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => ProductListPage()),
            GoRoute(
                path: '/product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailsPage(productId: id);
                }),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    );

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Product Dashboard',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}