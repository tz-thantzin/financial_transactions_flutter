// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_transactions_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recoverTransactionsUseCase)
final recoverTransactionsUseCaseProvider =
    RecoverTransactionsUseCaseProvider._();

final class RecoverTransactionsUseCaseProvider
    extends
        $FunctionalProvider<
          RecoverTransactionsUseCase,
          RecoverTransactionsUseCase,
          RecoverTransactionsUseCase
        >
    with $Provider<RecoverTransactionsUseCase> {
  RecoverTransactionsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recoverTransactionsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recoverTransactionsUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecoverTransactionsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecoverTransactionsUseCase create(Ref ref) {
    return recoverTransactionsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecoverTransactionsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecoverTransactionsUseCase>(value),
    );
  }
}

String _$recoverTransactionsUseCaseHash() =>
    r'8cb358d9e2c81e0e9dd63bd4dd0619b9af92fb11';
