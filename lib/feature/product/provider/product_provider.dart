 import 'package:api_learning/core/network/api_client.dart';
import 'package:api_learning/feature/product/data/model/product.dart';
import 'package:api_learning/feature/product/data/repository/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepository(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
Future<List<Product>> products(Ref ref) async {
  return ref.watch(productRepositoryProvider).getProducts();
}

@riverpod
Future<Product> singleProduct(Ref ref, {required int id}) async {
  return ref.watch(productRepositoryProvider).getSingleProduct(id: id);
}

@riverpod
Future<bool>createProduct(Ref ref,{required Product product})async{
  return ref.read(productRepositoryProvider).createProduct(product: product);
}

@riverpod
Future<bool>updateProduct(Ref ref ,{required int id, required Product product})async{
  return ref.watch(productRepositoryProvider).updateProduct(id: id, product: product);
}
