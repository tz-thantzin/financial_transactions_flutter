import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  static const String _storageKey = 'transactions_ledger';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> saveTransaction(TransactionModel transaction) async {
    final jsonStr = await _storage.read(key: _storageKey);
    List<dynamic> currentList = [];
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        currentList = json.decode(jsonStr);
      } catch (e) {
        currentList = [];
      }
    }

    final newJson = transaction.toJson();
    final existingIndex = currentList.indexWhere((item) {
      return item['clientTransactionId'] == transaction.clientTransactionId;
    });

    if (existingIndex >= 0) {
      currentList[existingIndex] = newJson;
    } else {
      currentList.add(newJson);
    }

    await _storage.write(key: _storageKey, value: json.encode(currentList));
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final jsonStr = await _storage.read(key: _storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonStr);
      return decoded.map((item) => TransactionModel.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }
}