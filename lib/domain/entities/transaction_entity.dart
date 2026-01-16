import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

enum TransactionStatus {
  created, // Persisted locally, not sent
  pending, // Sent, outcome unknown (Timeout/504)
  requiresVerification, // 403 Risk Challenge
  completed, // 200 OK
  failed, // 4xx/5xx definitive failure
}

@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String clientTransactionId,
    required int amount,
    required String beneficiaryId,
    required TransactionStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);
}