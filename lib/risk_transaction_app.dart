import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/router.dart';
import 'domain/usecases/recover_transactions_usecase.dart';
import 'presentation/viewmodels/risk_state_notifier.dart';

class RiskTransactionApp extends ConsumerStatefulWidget {
  const RiskTransactionApp({super.key});

  @override
  ConsumerState<RiskTransactionApp> createState() => _FintechAppState();
}

class _FintechAppState extends ConsumerState<RiskTransactionApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(recoverTransactionsUseCaseProvider)();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    ref.listen(riskChallengeProvider, (previous, next) {
      if (next is RiskUiOtp) {
        if (previous is RiskUiOtp && previous.transactionId == next.transactionId) {
          return;
        }

        final matches = router.routerDelegate.currentConfiguration.matches;
        final isOtpActive = matches.any((m) => m.matchedLocation == RoutePath.otp);

        if (!isOtpActive) {
          router.push(RoutePath.otp);
        }
      } else if (next is RiskUiNetworkError) {
        showDialog(
          context: router.routerDelegate.navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Connection Lost"),
            content: const Text(
              "Your transaction has been paused due to network issues. The Transaction ID remains reserved.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(riskChallengeProvider.notifier).resolveChallenge(true); // Retry
                },
                child: const Text("Retry Now"),
              ),
            ],
          ),
        );
      } else if (next is RiskUiNone) {
        final matches = router.routerDelegate.currentConfiguration.matches;
        final isOtpActive = matches.any((m) => m.matchedLocation == RoutePath.otp);

        if (isOtpActive && router.canPop()) {
          router.pop();
        }
      }
    });

    return MaterialApp.router(title: 'Transaction', routerConfig: router, debugShowCheckedModeBanner: false);
  }
}
