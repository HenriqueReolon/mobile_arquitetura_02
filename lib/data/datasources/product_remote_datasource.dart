import 'dart:convert';
import '../../core/api_client.dart';
import '../models/product_model.dart';
import '../../core/exceptions.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource({required this.apiClient});

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await apiClient.client.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ao carregar produtos. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Falha de comunicação com a API');
    }
  }

  Future<ProductModel> fetchProduct(int id) async {
    try {
      final response = await apiClient.client.get(Uri.parse('https://api.escuelajs.co/api/v1/products/$id'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return ProductModel.fromJson(jsonMap);
      } else {
        throw ServerException('Erro ao carregar produto. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Falha de comunicação com a API');
    }
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final response = await apiClient.client.post(
        Uri.parse('https://api.escuelajs.co/api/v1/products/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()..remove('id')),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Erro ao adicionar produto. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Falha de comunicação com a API ao adicionar produto: $e');
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await apiClient.client.put(
        Uri.parse('https://api.escuelajs.co/api/v1/products/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      
      if (response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Erro ao atualizar produto. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Falha de comunicação com a API ao atualizar produto: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiClient.client.delete(
        Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
      );
      
      if (response.statusCode != 200 && response.statusCode != 204 && response.statusCode != 201) {
        throw ServerException('Erro ao excluir produto. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Falha de comunicação com a API ao excluir produto');
    }
  }
}
