import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/transaction_viewmodel.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Column(
                  children: [
                    Text("Send Money", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    SizedBox(height: 8),
                    Text("\$50.00", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 30),

              Expanded(
                child: Center(
                  child: state.when(
                    initial: () => const Text("Ready to transfer", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    loading: () => const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [CircularProgressIndicator(), SizedBox(height: 16), Text("Processing Transaction...")],
                    ),
                    success: (t) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          "Transaction Successful!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          "ID: ${t.clientTransactionId}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    pending: (t) => const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_filled, color: Colors.orange, size: 64),
                        SizedBox(height: 16),
                        Text("Status Unknown (Timeout)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                          "The server took too long. We will reconcile this automatically.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    error: (msg) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 64),
                        const SizedBox(height: 16),
                        const Text("Transaction Failed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          msg.contains("403") ? "Verification Cancelled" : msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.maybeWhen(loading: () => true, orElse: () => false)
                      ? null
                      : () => ref.read(transactionViewModelProvider.notifier).initiateTransfer(50, "User_B"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
                  child: const Text("PAY NOW"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
