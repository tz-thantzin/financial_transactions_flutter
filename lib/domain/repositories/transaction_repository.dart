import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  /// Create local record
  Future<void> saveTransaction(TransactionEntity transaction);

  /// Attempt execution (Network)
  /// Returns the updated transaction (e.g., moved to completed or pending)
  Future<TransactionEntity> executeTransaction(TransactionEntity transaction);

  /// Update status (used during recovery or risk flows)
  Future<void> updateStatus(String id, TransactionStatus status);

  /// Retrieve all pending/risky transactions for recovery
  Future<List<TransactionEntity>> getUnresolvedTransactions();
}
