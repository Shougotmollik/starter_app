// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internet_checker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reactive, battery-friendly Riverpod stream listening to OS network changes.

@ProviderFor(internetStatus)
const internetStatusProvider = InternetStatusProvider._();

/// Reactive, battery-friendly Riverpod stream listening to OS network changes.

final class InternetStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Reactive, battery-friendly Riverpod stream listening to OS network changes.
  const InternetStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internetStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internetStatusHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return internetStatus(ref);
  }
}

String _$internetStatusHash() => r'69bc9bed6e7364fa1a290a7c5867af9d39eeb1f3';
