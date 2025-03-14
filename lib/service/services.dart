import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:kpifit/config/constant.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/service/common_service.dart';
import 'package:kpifit/util/widget_notifikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreService {
  late CommonService api;
  String connErr = 'Please check your internet connection and try again';

  CoreService(context) {
    api = CommonService(context);
  }

  Future<String> login(
      String user, String password, BuildContext context) async {
    final data = {'kode': "login", 'usernameemail': user, 'password': password};

    try {
      Response response = await api.postHTTP(API_URL, data);

      if (response.data['status'] == "success") {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('nik', response.data['nik']);
        notifikasiSuccess(response.data['message']);
        return response.data['status'];
      } else {
        notifikasiFailed(response.data['message']);
        return response.data['status'];
      }
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan, silakan coba lagi.";

      if (e.response != null) {
        // Jika ada response dari server, tampilkan error aslinya
        errorMessage = e.response?.data.toString() ?? "Error tanpa pesan.";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Koneksi timeout, periksa jaringan Anda.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server tidak merespons tepat waktu.";
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.type.name;
      } else if (e.type == DioExceptionType.unknown) {
        errorMessage = "Kesalahan tidak diketahui, periksa koneksi Anda.";
      }

      notifikasiFailed(errorMessage);
      return "error";
    } catch (e) {
      notifikasiFailed("Terjadi kesalahan: ${e.toString()}");
      return "error";
    }
  }

  Future<UserModel?> myProfile() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final nik = sharedPreferences.get('nik');
    final data = {
      'key': 'aisd9i9123nasd7m298masd9iaasdn9n812basdn',
      'kode': 'login',
      'nik': nik
    };

    try {
      Response response = await api.postHTTP(API_URL, data);
      if (response.data['status'] == "success") {
        notifikasiSuccess(response.data['message']);
        return UserModel.fromJson(response.data);
      }
      notifikasiFailed(response.data['message']);
      return null;
    } catch (e) {
      notifikasiFailed("Terjadi kesalahan, silakan coba lagi.");
      return null;
    }
  }

  Future<List<SportModel>> fetchOlahragaList() async {
    final data = {'kode': 'listolahraga'};

    try {
      Response response = await api.postHTTP(API_URL, data);
      if (response.data['status'] == "success") {
        List<dynamic> dataList = response.data['dataListOlahraga'] ?? [];
        return dataList.map((e) => SportModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
