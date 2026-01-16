// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionViewModel)
final transactionViewModelProvider = TransactionViewModelProvider._();

final class TransactionViewModelProvider
    extends $NotifierProvider<TransactionViewModel, TransactionState> {
  TransactionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionViewModelHash();

  @$internal
  @override
  TransactionViewModel create() => TransactionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionState>(value),
    );
  }
}

String _$transactionViewModelHash() =>
    r'56d239e3d8fb89ebc79d25905642211e40acbd1b';

abstract class _$TransactionViewModel extends $Notifier<TransactionState> {
  TransactionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TransactionState, TransactionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionState, TransactionState>,
              TransactionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
