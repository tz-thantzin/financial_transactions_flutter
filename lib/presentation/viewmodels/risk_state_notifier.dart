import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'risk_state_notifier.g.dart';

sealed class RiskUiState {
  const RiskUiState();
}

class RiskUiNone extends RiskUiState {
  const RiskUiNone();
}

class RiskUiOtp extends RiskUiState {
  final String transactionId;

  const RiskUiOtp(this.transactionId);
}

class RiskUiNetworkError extends RiskUiState {
  const RiskUiNetworkError();
}

@riverpod
class RiskChallenge extends _$RiskChallenge {
  Completer<bool>? _challengeCompleter;
  String? _lastVerifiedId; // Tracks the last successfully verified ID

  @override
  RiskUiState build() {
    return const RiskUiNone();
  }

  /// Trigger OTP Challenge (403)
  /// Prevents duplicate screens if called multiple times rapidly.
  Future<bool> triggerChallenge(String transactionId) {
    // If we just verified this ID, bypass UI and return true.
    if (transactionId == _lastVerifiedId) {
      return Future.value(true);
    }

    // If already showing OTP, wait for existing future.
    if (state is RiskUiOtp && _challengeCompleter != null && !_challengeCompleter!.isCompleted) {
      return _challengeCompleter!.future;
    }

    state = RiskUiOtp(transactionId);
    _challengeCompleter = Completer<bool>();
    return _challengeCompleter!.future;
  }

  /// Trigger Network Error Alert (No Connection)
  /// Pauses the request until the user clicks "Retry".
  Future<bool> triggerNetworkError() {
    // Concurrency Guard
    if (state is RiskUiNetworkError && _challengeCompleter != null && !_challengeCompleter!.isCompleted) {
      return _challengeCompleter!.future;
    }

    state = const RiskUiNetworkError();
    _challengeCompleter = Completer<bool>();
    return _challengeCompleter!.future;
  }

  /// [success]: true = Retry Request, false = Cancel/Fail Request
  void resolveChallenge(bool success) {
    // If successful, mark this ID as verified to prevent loops/re-triggering
    if (success && state is RiskUiOtp) {
      _lastVerifiedId = (state as RiskUiOtp).transactionId;
    }

    // Clear UI state immediately
    state = const RiskUiNone();

    // Resume the network request
    Future.microtask(() {
      if (_challengeCompleter != null && !_challengeCompleter!.isCompleted) {
        _challengeCompleter!.complete(success);
      }
      _challengeCompleter = null;
    });
  }
}
