import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/transaction_repository_impl.dart';
import '../repositories/transaction_repository.dart';

part 'recover_transactions_usecase.g.dart';

@riverpod
RecoverTransactionsUseCase recoverTransactionsUseCase(Ref ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return RecoverTransactionsUseCase(repository);
}

class RecoverTransactionsUseCase {
  final TransactionRepository _repository;

  RecoverTransactionsUseCase(this._repository);

  Future<void> call() async {
    final pending = await _repository.getUnresolvedTransactions();
    for (var txn in pending) {
      await _repository.executeTransaction(txn);
    }
  }
}
