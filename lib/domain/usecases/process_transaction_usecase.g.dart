// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_transaction_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(processTransactionUseCase)
final processTransactionUseCaseProvider = ProcessTransactionUseCaseProvider._();

final class ProcessTransactionUseCaseProvider
    extends
        $FunctionalProvider<
          ProcessTransactionUseCase,
          ProcessTransactionUseCase,
          ProcessTransactionUseCase
        >
    with $Provider<ProcessTransactionUseCase> {
  ProcessTransactionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'processTransactionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$processTransactionUseCaseHash();

  @$internal
  @override
  $ProviderElement<ProcessTransactionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProcessTransactionUseCase create(Ref ref) {
    return processTransactionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcessTransactionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcessTransactionUseCase>(value),
    );
  }
}

String _$processTransactionUseCaseHash() =>
    r'db02fbb56498621039d51c888f0b835e0435873f';
