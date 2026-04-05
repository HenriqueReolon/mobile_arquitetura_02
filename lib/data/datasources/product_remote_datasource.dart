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
}
