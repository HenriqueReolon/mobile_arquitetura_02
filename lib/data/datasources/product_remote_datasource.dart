import 'dart:convert';
import '../../core/api_client.dart';
import '../models/product_model.dart';
import '../../core/exceptions.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource({required this.apiClient});

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await apiClient.client.get(Uri.parse('https://fakestoreapi.com/products'));
      
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
}
