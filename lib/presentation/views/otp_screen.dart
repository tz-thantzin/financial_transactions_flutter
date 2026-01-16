import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/risk_state_notifier.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isVerified = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitOtp() {
    final code = _controller.text;
    final notifier = ref.read(riskChallengeProvider.notifier);

    if (code == "1234") {
      _isVerified = true;
      notifier.resolveChallenge(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong OTP (Try 1234)")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine Transaction ID from state
    final riskState = ref.watch(riskChallengeProvider);
    String? transactionId;
    if (riskState is RiskUiOtp) {
      transactionId = riskState.transactionId;
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !_isVerified) {
          Future.microtask(() {
            if (mounted) ref.read(riskChallengeProvider.notifier).resolveChallenge(false);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.red.shade50,
        appBar: AppBar(title: const Text("Security Check")),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text("Verification Required", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Unusual activity detected.\nPlease confirm this transaction.", textAlign: TextAlign.center),
                const SizedBox(height: 30),

                if (transactionId != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      children: [
                        const Text("Transaction ID", style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        SelectableText(transactionId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter OTP (1234)', filled: true, fillColor: Colors.white),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitOtp,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text("Verify Identity"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}