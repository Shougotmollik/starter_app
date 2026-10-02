import 'package:api_learning/core/network/api_client.dart';
import 'package:api_learning/core/network/api_response.dart';
import 'package:api_learning/feature/product/data/model/product.dart';

class ProductRepository {
  ProductRepository(this._apiClient);

  final ApiClient _apiClient;

  // get all product
  Future<List<Product>> getProducts() async {
    final ApiResponse<List<Product>> response = await _apiClient
        .get<List<Product>>(
          path: '/products',
          needAuth: false,
          checkInternet: true,
          responseParser: (data) {
            if (data is! List) {
              return <Product>[];
            }

            return data
                .map(
                  (item) =>
                      Product.fromJson(Map<String, dynamic>.from(item as Map)),
                )
                .toList();
          },
        );

    if (response.isSuccess) {
      return response.data ?? <Product>[];
    }

    throw Exception(response.message ?? 'Failed to load products');
  }

  // get single product
  Future<Product> getSingleProduct({required int id}) async {
    final ApiResponse<Product> response = await _apiClient.get<Product>(
      path: '/products/$id',
      needAuth: false,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception('Product not found');
        }

        return Product.fromJson(Map<String, dynamic>.from(data));
      },
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load product');
  }

  // create product
  Future<bool> createProduct({required Product product}) async {
    final ApiResponse<Map<String, dynamic>> response = await _apiClient
        .post<Map<String, dynamic>>(
          path: '/products',
          data: product.toJson(),
          needAuth: false,
          checkInternet: true,
          responseParser: (data) {
            if (data == null || data is! Map) {
              throw Exception('Failed to create product');
            }
            return Map<String, dynamic>.from(data);
          },
        );

    return response.isSuccess && response.data != null;
  }

  // update product
  Future<bool> updateProduct({
    required int id,
    required Product product,
  }) async {
    final ApiResponse response = await _apiClient.put(
      path: "/products$id",
      data: product.toJson(),
      needAuth: false,
      checkInternet: true,
      responseParser: (data) {
        if (data == null || data is! Map) {
          throw Exception("Failed to updated data");
        }
        return Map.from(data);
      },
    );
    return response.isSuccess && response.data != null;
  }
}
