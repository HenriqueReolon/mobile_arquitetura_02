import 'package:flutter/material.dart';
import '../../domain/repositories/product_repository.dart';
import 'products_page.dart';

class HomePage extends StatelessWidget {
  final ProductRepository repository;

  const HomePage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsPage(repository: repository),
              ),
            );
          },
          child: const Text('Ver Produtos'),
        ),
      ),
    );
  }
}
