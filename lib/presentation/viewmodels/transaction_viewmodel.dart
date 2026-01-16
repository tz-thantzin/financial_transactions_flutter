import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/process_transaction_usecase.dart';

part 'transaction_viewmodel.freezed.dart';

part 'transaction_viewmodel.g.dart';

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;

  const factory TransactionState.loading() = _Loading;

  const factory TransactionState.success(TransactionEntity t) = _Success;

  const factory TransactionState.pending(TransactionEntity t) = _Pending;

  const factory TransactionState.error(String msg) = _Error;
}

@riverpod
class TransactionViewModel extends _$TransactionViewModel {
  @override
  TransactionState build() => const TransactionState.initial();

  Future<void> initiateTransfer(int amount, String beneficiary) async {
    state = const TransactionState.loading();
    final processUseCase = ref.read(processTransactionUseCaseProvider);
    final txnId = const Uuid().v4();

    final transaction = TransactionEntity(
      clientTransactionId: txnId,
      amount: amount,
      beneficiaryId: beneficiary,
      status: TransactionStatus.created,
      createdAt: DateTime.now(),
    );

    try {
      final result = await processUseCase(transaction);
      if (result.status == TransactionStatus.completed) {
        state = TransactionState.success(result);
      } else if (result.status == TransactionStatus.pending) {
        state = TransactionState.pending(result);
      } else {
        state = const TransactionState.error("Transaction failed definitively");
      }
    } catch (e) {
      state = TransactionState.error(e.toString());
    }
  }
}
