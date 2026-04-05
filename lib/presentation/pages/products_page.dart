import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_details_page.dart';
import 'product_form_page.dart';

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

  Future<void> _deleteProduct(Product product) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Produto'),
        content: Text('Deseja realmente excluir "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      setState(() {
        _state = ProductsLoading();
      });
      await widget.repository.deleteProduct(product.id);
      _loadProducts(); // Recarrega a lista
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e')),
        );
        _loadProducts(); // Retorna ao estado anterior recarregando
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
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                      ),
                      title: Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('\$${product.price}'),
                      trailing: Wrap(
                        spacing: -8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductFormPage(
                                    repository: widget.repository,
                                    product: product,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _loadProducts(); // Recarrega
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(product),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                              repository: widget.repository,
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        },
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductFormPage(
                  repository: widget.repository,
                ),
              ),
            );
            if (result == true) {
              _loadProducts(); // Recarrega
            }
          },
          child: const Icon(Icons.add),
        ),
      );
    }
  }
