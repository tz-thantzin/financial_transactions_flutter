import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../models/transaction_model.dart';

class TransactionApiService {
  final Dio _dio;

  TransactionApiService(this._dio) {
    _dio.httpClientAdapter = _MockAdapter();
  }

  Future<Response> submitTransaction(TransactionModel transaction) async {
    // Calling .post triggers Interceptors (Risk/Network)
    return _dio.post('/transfer', data: transaction.toJson());
  }
}

class _MockAdapter implements HttpClientAdapter {
  final Random _random = Random();
  final Set<String> _challengedTransactionIds = {};

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future? cancelFuture) async {
    // 1. PRE-CHECK: Inspect actual device network connectivity first.
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: "No internet connection detected by Mock Adapter",
      );
    }

    String txnId = 'unknown';
    if (options.data is Map) {
      txnId = options.data['clientTransactionId'] ?? 'unknown';
    } else if (options.data is String) {
      try {
        final map = jsonDecode(options.data);
        txnId = map['clientTransactionId'] ?? 'unknown';
      } catch (_) {}
    }

    // Bypass check to prevent infinite loop
    bool bypassRisk = false;
    if (txnId != 'unknown' && _challengedTransactionIds.contains(txnId)) {
      bypassRisk = true;
    }

    final outcome = _random.nextInt(100);
    int delay;

    // --- TIMING LOGIC ---
    if (outcome >= 20 && outcome < 30) {
      // 504 Timeout (>10s)
      delay = 11000 + _random.nextInt(4000);
    } else if (outcome >= 40) {
      // 200 Success: Set 5 seconds
      delay = 5000;
    } else {
      // Other errors (403 Risk, 500 Server Error) -> Fast
      delay = 300 + _random.nextInt(500);
    }

    // Simulate processing time
    await Future.delayed(Duration(milliseconds: delay));

    // 2. POST-CHECK: Verify connectivity AGAIN after the delay.
    // This handles the case where the user turns off the network *during* the 7-second wait.
    final connectivityResultAfter = await Connectivity().checkConnectivity();
    if (connectivityResultAfter.contains(ConnectivityResult.none)) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: "Connection lost during transaction processing",
      );
    }

    // 403 Risk (0-19)
    if (!bypassRisk && outcome < 20) {
      if (txnId != 'unknown') _challengedTransactionIds.add(txnId);
      return _buildResponse(403, {'error': 'risk_challenge_required', 'message': 'Unusual activity detected.'});
    }

    // 504 Timeout (20-29)
    if (outcome < 30) {
      return _buildResponse(504, {'error': 'gateway_timeout'});
    }

    // 500 Error (30-39)
    if (outcome < 40) {
      return _buildResponse(500, {'error': 'internal_error'});
    }

    // 200 Success (40-99)
    return _buildResponse(200, {'status': 'success', 'client_id': txnId});
  }

  ResponseBody _buildResponse(int code, Map<String, dynamic> data) {
    return ResponseBody.fromString(
      jsonEncode(data),
      code,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
