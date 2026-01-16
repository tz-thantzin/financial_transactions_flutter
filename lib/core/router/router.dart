import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/views/otp_screen.dart';
import '../../presentation/views/transaction_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: RoutePath.initial,
    routes: [
      GoRoute(path: RoutePath.initial, name: RouteName.initial, builder: (context, state) => const TransactionScreen()),
      GoRoute(path: RoutePath.otp, name: RouteName.otp, builder: (context, state) => const OtpScreen()),
    ],
  );
}

class RoutePath {
  static const String initial = '/';
  static const String otp = '/otp';
}

class RouteName {
  static const String initial = '/';
  static const String otp = 'otp';
}
