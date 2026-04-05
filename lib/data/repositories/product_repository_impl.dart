import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

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

  @override
  Future<Product> addProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      image: product.image,
    );
    final result = await remoteDataSource.addProduct(productModel);
    _cachedProducts?.add(result);
    return result;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      image: product.image,
    );
    final result = await remoteDataSource.updateProduct(productModel);
    if (_cachedProducts != null) {
      final index = _cachedProducts!.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _cachedProducts![index] = result;
      }
    }
    return result;
  }

  @override
  Future<void> deleteProduct(int id) async {
    await remoteDataSource.deleteProduct(id);
    _cachedProducts?.removeWhere((p) => p.id == id);
  }
}
