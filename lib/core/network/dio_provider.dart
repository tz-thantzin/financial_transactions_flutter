import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/viewmodels/risk_state_notifier.dart';
import '../constants/constant_api.dart';
import 'risk_interceptor.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dioInstance = Dio(
    BaseOptions(
      baseUrl: ApiConstants.host,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final riskNotifier = ref.read(riskChallengeProvider.notifier);

  dioInstance.interceptors.add(RiskInterceptor(dio: dioInstance, notifier: riskNotifier));

  return dioInstance;
}
