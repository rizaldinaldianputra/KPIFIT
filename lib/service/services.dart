import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';

import 'package:kpifit/config/constant.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/riverpod/home.dart';
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
    final data = {'usernameemail': user, 'password': password};

    Response response = await api.postHTTP('${baseUrl}login', data);

    if (response.data['status'] == "success") {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('nik', response.data['nik']);
      await CoreService(context).myProfile();

      notifikasiSuccess(response.data['message']);
      List<SportModel> result = await CoreService(context).fetchOlahragaList();
      var existingData = HiveService.loadSportData(); // Ambil data dari Hive

      for (var element in result) {
        if (!existingData.contains(element)) {
          await HiveService.saveSportData(element);
        }
      }
      context.goNamed('home');
      return response.data['status'];
    } else {
      notifikasiFailed(response.data['message']);
      return response.data['status'];
    }
  }

  Future<UserModel> myProfile() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final nik = sharedPreferences.getString('nik') ?? '';

      if (nik.isEmpty) {
        debugPrint("NIK tidak ditemukan di SharedPreferences");
        return UserModel.blank();
      }

      final data = {'nik': nik};

      Response response = await api.postHTTP('${baseUrl}cekprofil', data);

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['status'] == "success") {
          final user = UserModel.fromJson(responseData);

          // Simpan data UserModel ke SharedPreferences
          await sharedPreferences.setString('user_data', user.toJsonString());

          return user;
        }
      } else {
        debugPrint("Format response tidak valid.");
      }
    } catch (e) {
      debugPrint("Error saat mengambil profil: $e");
    }

    return UserModel.blank();
  }

  Future<List<SportModel>> fetchOlahragaList() async {
    try {
      Response response = await api.getHTTP('${baseUrl}listolahraga');

      if (response.data['status'] == "success") {
        List<dynamic> dataList = response.data['dataListOlahraga'] ?? [];
        return dataList.map((e) => SportModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<String> changePassword(
      {required String user,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword,
      required BuildContext context,
      required WidgetRef ref}) async {
    final data = {
      "usernameemail": user,
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword
    };

    Response response = await api.postHTTP('${baseUrl}changepassword', data);

    if (response.data['status'] == "success") {
      notifikasiSuccess(response.data['message']);
      GoRouter.of(context).goNamed('home');
      ref.watch(homePageProvider.notifier).jumpToPage(0);

      return response.data['status'];
    } else {
      notifikasiFailed(response.data['message']);
      return response.data['status'];
    }
  }

  Future<List<AktivitasModel>> fetchAktifitas() async {
    try {
      Response response = await api.getHTTP('${baseUrl}logaktifitas');

      if (response.data['status'] == "success") {
        List<dynamic> dataList = response.data['data'];
        return dataList.map((e) => AktivitasModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<UserModel> getUserFromPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString('user_data');

    if (userData != null) {
      return UserModel.fromJsonString(userData);
    }

    return UserModel.blank();
  }

  Future<String> uploadAktifitas(
      AktivitasModel workoutModel, BuildContext context) async {
    final user = await getUserFromPrefs();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Ambil data UserModel dari SharedPreferences
    final nik = sharedPreferences.getString('nik') ?? '';

    FormData formData = FormData.fromMap({
      'nik': nik,
      'nama': user.nama,
      'namaolahraga': workoutModel.namaOlahraga,
      'tanggal': workoutModel.tanggal,
      'totalwaktu': workoutModel.totalWaktu,
      'lokasi': workoutModel.lokasi,
      'latitude': workoutModel.latitude,
      'longitude': workoutModel.longitude,
      'foto': workoutModel.foto.isNotEmpty
          ? await MultipartFile.fromFile(workoutModel.foto,
              contentType: MediaType('image', 'jpeg'),
              filename:
                  'foto -${workoutModel.namaOlahraga} + ${DateTime.now()}.jpg')
          : null,
      'lampiran': workoutModel.lampiran.isNotEmpty
          ? await MultipartFile.fromFile(workoutModel.lampiran,
              contentType: MediaType('image', 'jpeg'),
              filename:
                  'lampiran -${workoutModel.namaOlahraga} + ${DateTime.now()}.jpg')
          : null,
    });

    Response response =
        await api.postHTTPMedia('${baseUrl}simpanlogaktifitas', formData);

    if (response.data['status'] == "success") {
      notifikasiSuccess(response.data['message']);
      context.goNamed('home');
      return response.data['status'];
    } else {
      notifikasiFailed(response.data['message']);
      return response.data['status'];
    }
  }
}
