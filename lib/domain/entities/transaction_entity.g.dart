// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionEntity _$TransactionEntityFromJson(Map<String, dynamic> json) =>
    _TransactionEntity(
      clientTransactionId: json['clientTransactionId'] as String,
      amount: (json['amount'] as num).toInt(),
      beneficiaryId: json['beneficiaryId'] as String,
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionEntityToJson(_TransactionEntity instance) =>
    <String, dynamic>{
      'clientTransactionId': instance.clientTransactionId,
      'amount': instance.amount,
      'beneficiaryId': instance.beneficiaryId,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.created: 'created',
  TransactionStatus.pending: 'pending',
  TransactionStatus.requiresVerification: 'requiresVerification',
  TransactionStatus.completed: 'completed',
  TransactionStatus.failed: 'failed',
};
