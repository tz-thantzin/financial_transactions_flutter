import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/viewmodels/risk_state_notifier.dart';

class RiskInterceptor extends Interceptor {
  final Dio dio;
  final RiskChallenge notifier;

  RiskInterceptor({required this.dio, required this.notifier});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // SCENARIO 1: Network Disconnected / Connection Error
    // Catch connection errors, timeouts, and socket exceptions
    // as "Retryable Network Errors" instead of failing or treating as 504.
    final isNetworkError =
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.type == DioExceptionType.unknown && err.error.toString().contains("SocketException"));

    if (isNetworkError) {
      debugPrint('[RiskInterceptor] Network Error detected (${err.type}). Pausing...');

      try {
        // Trigger Alert Dialog via Notifier (Handled in main.dart)
        // This pauses execution until the user presses "Retry"
        final shouldRetry = await notifier.triggerNetworkError();

        if (shouldRetry) {
          debugPrint('[RiskInterceptor] User requested retry. Retrying...');
          // Retry the EXACT same request (idempotency safe)
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } else {
          return handler.next(err);
        }
      } catch (e) {
        return handler.next(err);
      }
    }

    // SCENARIO 2: 403 RISK CHALLENGE
    if (err.response?.statusCode == 403) {
      debugPrint('[RiskInterceptor] Risk Challenge Triggered. Pausing request...');

      // Extract Transaction ID
      String txnId = "Unknown ID";
      try {
        final data = err.requestOptions.data;
        if (data is Map) {
          txnId = data['clientTransactionId'] ?? "Unknown ID";
        } else if (data is String) {
          final map = jsonDecode(data);
          txnId = map['clientTransactionId'] ?? "Unknown ID";
        }
      } catch (e) {
        debugPrint("Could not extract ID: $e");
      }

      try {
        // Trigger OTP UI
        final isVerified = await notifier.triggerChallenge(txnId);

        if (isVerified) {
          debugPrint('[RiskInterceptor] Challenge Passed. Retrying original request...');
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } else {
          return handler.next(err); // User cancelled
        }
      } catch (e) {
        return handler.next(err);
      }
    }

    // SCENARIO 3: 504 TIMEOUT (Upstream Server Issue)
    // Note: connectionTimeout was moved to Scenario 1 as it's usually client-side.
    // This block now handles genuine gateway timeouts (server reached but slow).
    if (err.response?.statusCode == 504) {
      return handler.resolve(
        Response(requestOptions: err.requestOptions, statusCode: 504, data: {'status': 'timeout_unknown_state'}),
      );
    }

    return handler.next(err);
  }
}
