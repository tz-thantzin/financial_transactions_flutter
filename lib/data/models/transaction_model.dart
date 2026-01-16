import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String clientTransactionId,
    required int amount,
    required String beneficiaryId,
    required String status,
    required String createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionMapper on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      clientTransactionId: clientTransactionId,
      amount: amount,
      beneficiaryId: beneficiaryId,
      status: TransactionStatus.values.firstWhere((e) => e.name == status),
      createdAt: DateTime.parse(createdAt),
    );
  }
}

extension EntityMapper on TransactionEntity {
  TransactionModel toModel() {
    return TransactionModel(
      clientTransactionId: clientTransactionId,
      amount: amount,
      beneficiaryId: beneficiaryId,
      status: status.name,
      createdAt: createdAt.toIso8601String(),
    );
  }
}