// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RiskChallenge)
final riskChallengeProvider = RiskChallengeProvider._();

final class RiskChallengeProvider
    extends $NotifierProvider<RiskChallenge, RiskUiState> {
  RiskChallengeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'riskChallengeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$riskChallengeHash();

  @$internal
  @override
  RiskChallenge create() => RiskChallenge();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RiskUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RiskUiState>(value),
    );
  }
}

String _$riskChallengeHash() => r'fd67e25ad7cfcf65506356dee197721c2840d0ca';

abstract class _$RiskChallenge extends $Notifier<RiskUiState> {
  RiskUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RiskUiState, RiskUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RiskUiState, RiskUiState>,
              RiskUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
