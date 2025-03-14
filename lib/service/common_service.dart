import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as diopackage;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/config/constant.dart';
import 'package:kpifit/util/widget_notifikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonService {
  static const String url = API_URL;
  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
  );

  late final Dio _dio;

  CommonService(BuildContext context) {
    _dio = Dio(opts);
    _dio.interceptors.add(getInterceptorWrapper(context));
  }

  InterceptorsWrapper getInterceptorWrapper(BuildContext context) {
    return InterceptorsWrapper(
      onError: (error, errorInterceptor) async {
        if (error.response == null) {
          notifikasiFailed('Network Error');
          // final SharedPreferences sharedPreferences =
          //     await SharedPreferences.getInstance();
          // await sharedPreferences.remove("user");
          // await sharedPreferences.remove("token");

          // // Navigasi ke halaman login
          // GoRouter.of(context).goNamed('login');
          return errorInterceptor.resolve(
              error.response ?? Response(requestOptions: error.requestOptions));
        }
        if (error.response!.statusCode == 403 ||
            error.response!.statusCode == 401) {
          notifikasiFailed(error.response!.statusCode == 403
              ? error.response?.data["message"]
              : error.response?.data["message"]);
          return errorInterceptor.resolve(error.response!);
        } else {
          return errorInterceptor.resolve(error.response!);
        }
      },
      onRequest: (request, requestInterceptor) async {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        final String? token = sharedPreferences.getString("token");
        if (token != null) {
          request.headers.addAll({"Authorization": "Bearer $token"});
        }
        return requestInterceptor.next(request);
      },
      onResponse: (response, responseInterceptor) async {
        if (response.statusCode == 401 || response.statusCode == 403) {
          // Hapus token jika tidak valid
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.remove("user");
          await sharedPreferences.remove("token");

          // Navigasi ke halaman login
          GoRouter.of(context).goNamed('login');
          return;
        }
        return responseInterceptor.next(response);
      },
    );
  }

  static dynamic errorInterceptor(RequestOptions options) async {
    // Get your JWT token
    const token = '';
    options.headers.addAll({"Authorization": "Bearer: $token"});
    return options;
  }

  Future<diopackage.Response> getHTTP(String url) async {
    try {
      diopackage.Response response = await _dio.get(url);
      return Future.value(response);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }

  Future<diopackage.Response> postHTTP(String url, dynamic data) async {
    try {
      String json = jsonEncode(data);

      diopackage.Response response = await _dio.post(url, data: json);
      return response;
    } on DioException catch (e) {
      if (e.response == null) {
        return Future.error(e);
      } else {
        return Future.error(e.response?.data['message'] ?? "Unknown Error");
      }
    }
  }

  Future<diopackage.Response> putHTTP(String url, dynamic data) async {
    try {
      String json = jsonEncode(data);
      diopackage.Response response = await _dio.put(url, data: json);
      return Future.value(response);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }

  Future<diopackage.Response> deleteHTTP(String url) async {
    try {
      diopackage.Response response = await _dio.delete(url);
      return Future.value(response);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }

  Future<diopackage.Response> postHTTPMedia(String url, FormData data) async {
    try {
      diopackage.Response response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response == null) {
        return Future.error(e);
      } else {
        return Future.error(e.response!.data['message'] ?? "Unknown Error");
      }
    }
  }
}
