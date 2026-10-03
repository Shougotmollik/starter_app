// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRepository)
const productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  const ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'62f1d6882bf711b7900d0bdd2d79dd910099e28b';

@ProviderFor(products)
const productsProvider = ProductsProvider._();

final class ProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return products(ref);
  }
}

String _$productsHash() => r'b77f525fd11e508922345f308e01f76f04f0eba7';

@ProviderFor(singleProduct)
const singleProductProvider = SingleProductFamily._();

final class SingleProductProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  const SingleProductProvider._({
    required SingleProductFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'singleProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleProductHash();

  @override
  String toString() {
    return r'singleProductProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as int;
    return singleProduct(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleProductHash() => r'e0272a50a8f23aaa82dc3a7c63f4a779c5aa9cb6';

final class SingleProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, int> {
  const SingleProductFamily._()
    : super(
        retry: null,
        name: r'singleProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SingleProductProvider call({required int id}) =>
      SingleProductProvider._(argument: id, from: this);

  @override
  String toString() => r'singleProductProvider';
}

@ProviderFor(createProduct)
const createProductProvider = CreateProductFamily._();

final class CreateProductProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const CreateProductProvider._({
    required CreateProductFamily super.from,
    required Product super.argument,
  }) : super(
         retry: null,
         name: r'createProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createProductHash();

  @override
  String toString() {
    return r'createProductProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as Product;
    return createProduct(ref, product: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createProductHash() => r'377d777f216d647ce0cbe765840702af22359798';

final class CreateProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, Product> {
  const CreateProductFamily._()
    : super(
        retry: null,
        name: r'createProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateProductProvider call({required Product product}) =>
      CreateProductProvider._(argument: product, from: this);

  @override
  String toString() => r'createProductProvider';
}

@ProviderFor(updateProduct)
const updateProductProvider = UpdateProductFamily._();

final class UpdateProductProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const UpdateProductProvider._({
    required UpdateProductFamily super.from,
    required ({int id, Product product}) super.argument,
  }) : super(
         retry: null,
         name: r'updateProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateProductHash();

  @override
  String toString() {
    return r'updateProductProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({int id, Product product});
    return updateProduct(ref, id: argument.id, product: argument.product);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateProductHash() => r'1e7a3eb0175bee3d54c703fcf7e64e31e9a35984';

final class UpdateProductFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<bool>, ({int id, Product product})> {
  const UpdateProductFamily._()
    : super(
        retry: null,
        name: r'updateProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateProductProvider call({required int id, required Product product}) =>
      UpdateProductProvider._(argument: (id: id, product: product), from: this);

  @override
  String toString() => r'updateProductProvider';
}
