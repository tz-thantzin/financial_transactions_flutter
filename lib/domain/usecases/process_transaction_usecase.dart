import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/transaction_repository_impl.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

part 'process_transaction_usecase.g.dart';

@riverpod
ProcessTransactionUseCase processTransactionUseCase(Ref ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return ProcessTransactionUseCase(repository);
}

class ProcessTransactionUseCase {
  final TransactionRepository _repository;

  ProcessTransactionUseCase(this._repository);

  Future<TransactionEntity> call(TransactionEntity transaction) async {
    await _repository.saveTransaction(transaction);
    return await _repository.executeTransaction(transaction);
  }
}
