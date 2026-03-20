import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

sealed class ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final List<Product> products;

  ProductsSuccess(this.products);
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError(this.message);
}

class ProductsPage extends StatefulWidget {
  final ProductRepository repository;

  const ProductsPage({super.key, required this.repository});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  ProductsState _state = ProductsLoading();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await widget.repository.getProducts();
      if (mounted) {
        setState(() {
          _state = ProductsSuccess(products);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = ProductsError(e.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: switch (_state) {
        ProductsLoading() => const Center(child: CircularProgressIndicator()),
        ProductsError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ProductsSuccess(:final products) => products.isEmpty
            ? const Center(child: Text('Nenhum produto encontrado.'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Image.network(product.image, width: 50, height: 50),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                  );
                },
              ),
      },
    );
  }
}
