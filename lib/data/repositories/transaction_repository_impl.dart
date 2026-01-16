import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_provider.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_api_service.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

part 'transaction_repository_impl.g.dart';

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return TransactionRepositoryImpl(
    localDataSource: TransactionLocalDataSource(),
    apiService: TransactionApiService(dio),
  );
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionApiService apiService;

  TransactionRepositoryImpl({required this.localDataSource, required this.apiService});

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    await localDataSource.saveTransaction(transaction.toModel());
  }

  @override
  Future<TransactionEntity> executeTransaction(TransactionEntity transaction) async {
    try {
      final response = await apiService.submitTransaction(transaction.toModel());

      if (response.statusCode == 200) {
        final updated = transaction.copyWith(status: TransactionStatus.completed);
        await saveTransaction(updated);
        return updated;
      } else if (response.statusCode == 504) {
        final updated = transaction.copyWith(status: TransactionStatus.pending);
        await saveTransaction(updated);
        return updated;
      }

      final updated = transaction.copyWith(status: TransactionStatus.failed);
      await saveTransaction(updated);
      return updated;
    } catch (e) {
      final updated = transaction.copyWith(status: TransactionStatus.pending);
      await saveTransaction(updated);
      return updated;
    }
  }

  @override
  Future<List<TransactionEntity>> getUnresolvedTransactions() async {
    final all = await localDataSource.getAllTransactions();
    return all
        .map((m) => m.toEntity())
        .where(
          (t) =>
              t.status == TransactionStatus.pending ||
              t.status == TransactionStatus.requiresVerification ||
              t.status == TransactionStatus.created,
        )
        .toList();
  }

  @override
  Future<void> updateStatus(String id, TransactionStatus status) async {
    final all = await localDataSource.getAllTransactions();
    final index = all.indexWhere((t) => t.clientTransactionId == id);
    if (index != -1) {
      final updated = all[index].toEntity().copyWith(status: status);
      await localDataSource.saveTransaction(updated.toModel());
    }
  }
}
