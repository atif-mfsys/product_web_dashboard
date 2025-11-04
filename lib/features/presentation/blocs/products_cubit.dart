import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';
import 'package:products_web_dashboard/features/data/products_repository.dart';
import 'package:uuid/uuid.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filtered;
  final String search;
  final String categoryFilter;
  final bool? inStockFilter; // null = all

  ProductLoaded({
    required this.products,
    required this.filtered,
    this.search = '',
    this.categoryFilter = 'All',
    this.inStockFilter,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filtered,
    String? search,
    String? categoryFilter,
    bool? inStockFilter,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filtered: filtered ?? this.filtered,
      search: search ?? this.search,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      inStockFilter: inStockFilter ?? this.inStockFilter,
    );
  }
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repo;
  final _uuid = Uuid();

  ProductCubit(this.repo) : super(ProductInitial());
  Future<void> load() async {
    emit(ProductLoading());
    try {
      final list = await repo.fetchProducts();
      emit(ProductLoaded(products: list, filtered: list));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _applyFilters(ProductLoaded state) {
    var list = state.products;
    if (state.search.isNotEmpty) {
      final s = state.search.toLowerCase();
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(s) ||
              p.category.toLowerCase().contains(s))
          .toList();
    }
    if (state.categoryFilter != 'All') {
      list = list.where((p) => p.category == state.categoryFilter).toList();
    }
    if (state.inStockFilter != null) {
      list = list.where((p) => p.inStock == state.inStockFilter).toList();
    }
    emit(state.copyWith(filtered: list));
  }

  void search(String s) {
    final st = state as ProductLoaded;
    emit(st.copyWith(search: s));
    _applyFilters(st.copyWith(search: s));
  }

  void filterByCategory(String category) {
    final st = state as ProductLoaded;
    emit(st.copyWith(categoryFilter: category));
    _applyFilters(st.copyWith(categoryFilter: category));
  }

  void filterByStock(bool? inStock) {
    final st = state as ProductLoaded;
    emit(st.copyWith(inStockFilter: inStock));
    _applyFilters(st.copyWith(inStockFilter: inStock));
  }

  void addProduct(Product p) {
    final st = state as ProductLoaded;
    final newList = [p, ...st.products];
    emit(st.copyWith(products: newList));
    _applyFilters(st.copyWith(products: newList));
  }

  void updateProduct(Product p) {
    final st = state as ProductLoaded;
    final newList = st.products.map((x) => x.id == p.id ? p : x).toList();
    emit(st.copyWith(products: newList));
    _applyFilters(st.copyWith(products: newList));
  }

  void deleteProduct(String id) {
    final st = state as ProductLoaded;
    final newList = st.products.where((x) => x.id != id).toList();
    emit(st.copyWith(products: newList));
    _applyFilters(st.copyWith(products: newList));
  }

  Product createLocalProduct(
      {required String title,
      required String category,
      required double price,
      required int stock}) {
    return Product(
        id: _uuid.v4(),
        title: title,
        category: category,
        price: price,
        stock: stock);
  }
}
