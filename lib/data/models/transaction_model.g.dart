// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      clientTransactionId: json['clientTransactionId'] as String,
      amount: (json['amount'] as num).toInt(),
      beneficiaryId: json['beneficiaryId'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'clientTransactionId': instance.clientTransactionId,
      'amount': instance.amount,
      'beneficiaryId': instance.beneficiaryId,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };
