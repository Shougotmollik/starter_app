import 'package:api_learning/feature/product/data/model/product.dart';
import 'package:api_learning/feature/product/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductView extends ConsumerWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) => _ProductList(products: products),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          child: ListTile(
            leading: product.image != null
                ? Image.network(
                    product.image!,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported),
            title: Text(product.title ?? 'No title'),
            subtitle: Text(product.category ?? 'Unknown category'),
            trailing: Text('\$${product.price?.toStringAsFixed(2) ?? '0.00'}'),
          ),
        );
      },
    );
  }
}
