import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  List<Product>? _cachedProducts;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await remoteDataSource.fetchProducts();
      _cachedProducts = products;
      return products;
    } catch (e) {
      if (_cachedProducts != null && _cachedProducts!.isNotEmpty) {
        return _cachedProducts!;
      }
      rethrow;
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    if (_cachedProducts != null) {
      try {
        return _cachedProducts!.firstWhere((p) => p.id == id);
      } catch (_) {
      }
    }
    return await remoteDataSource.fetchProduct(id);
  }
}
