import 'package:dio/dio.dart';
import 'package:products_web_dashboard/features/models/products_model.dart';

class ProductRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com', 
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<List<Product>> fetchProducts({int limit = 50}) async {
    try {
      final res =
          await _dio.get('/products?limit=$limit'); 
      final data = res.data['products'] as List;
      return data.map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      // Use DioException for better error handling
      throw Exception('Failed to load products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final res = await _dio.get('/products/$id'); 
      return Product.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception('Failed to load product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final res = await _dio.post(
        '/products/add', 
        data: product.toJson(),
      );
      return Product.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception('Failed to add product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      final res = await _dio.put(
        '/products/${product.id}',
        data: product.toJson(),
      );
      return Product.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception('Failed to update product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id'); 
      return true;
    } on DioException catch (e) {
      throw Exception('Failed to delete product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
