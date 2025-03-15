import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/config/constant.dart';
import 'package:kpifit/util/widget_notifikasi.dart';

class CommonService {
  static const String url = API_URL;
  static const String bearerToken =
      "aisd9i9123nasd7m298masd9iaasdn9n812basdn"; // Token tetap

  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
    headers: {
      "Authorization": "Bearer $bearerToken",
    },
  );

  late final Dio _dio;

  CommonService(BuildContext context) {
    _dio = Dio(opts);
    _dio.interceptors.add(getInterceptorWrapper(context));
  }

  InterceptorsWrapper getInterceptorWrapper(BuildContext context) {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          GoRouter.of(context).goNamed('login');
          notifikasiFailed("Session expired, please login again.");
        }
        return handler.next(error);
      },
    );
  }

  Future<Response> getHTTP(String url) async {
    try {
      return await _dio.get(url);
    } on DioException catch (e) {
      return Future.error(e.response?.data['message'] ?? "Unknown Error");
    }
  }

  Future<Response> postHTTP(String url, dynamic data) async {
    try {
      return await _dio.post(url, data: jsonEncode(data));
    } on DioException catch (e) {
      return Future.error(e.response?.data['message'] ?? "Unknown Error");
    }
  }

  Future<Response> putHTTP(String url, dynamic data) async {
    try {
      return await _dio.put(url, data: jsonEncode(data));
    } on DioException catch (e) {
      return Future.error(e.response?.data['message'] ?? "Unknown Error");
    }
  }

  Future<Response> deleteHTTP(String url) async {
    try {
      return await _dio.delete(url);
    } on DioException catch (e) {
      return Future.error(e.response?.data['message'] ?? "Unknown Error");
    }
  }

  Future<Response> postHTTPMedia(String url, FormData data) async {
    try {
      return await _dio.post(url, data: data);
    } on DioException catch (e) {
      return Future.error(e.response?.data['message'] ?? "Unknown Error");
    }
  }
}
