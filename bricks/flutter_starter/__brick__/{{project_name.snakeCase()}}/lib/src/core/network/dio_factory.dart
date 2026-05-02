import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';

Dio createDio(AppConfig config) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseApiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (config.enableNetworkLogs) {
    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: false,
          printResponseMessage: true,
        ),
      ),
    );
  }

  return dio;
}
