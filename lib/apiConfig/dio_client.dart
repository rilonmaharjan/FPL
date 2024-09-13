import 'package:dio/dio.dart';
import 'package:fantasypremiereleague/apiConfig/dio_interceptor.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: "https://fantasy.premierleague.com/api/",
    receiveDataWhenStatusError: true,
  ),
)..interceptors.add(DioInterceptor());


