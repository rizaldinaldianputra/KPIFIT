import 'package:dio/dio.dart';

import 'package:kpifit/config/constant.dart';
import 'package:kpifit/service/common_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late CommonService api;
  String connErr = 'Please check your internet connection and try again';

  AuthService(context) {
    api = CommonService(context);
  }

  Future<void> authenticate(String user, String password, context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final data = {'username': user, 'password': password};
    String url = '$API_URL/authenticate';
    Response response = await api.postHTTP(url, data);
  }

//   Future<UserModel> signup(UserModel usermodel, String capchaText,
//       String uniqueId, BuildContext context) async {
//     Map<String, dynamic> data = {
//       "fullName": usermodel.fullName,
//       "email": usermodel.email,
//       "phoneNumber": usermodel.phoneNumber,
//       "password": usermodel.password,
//       "latitude": usermodel.latitude,
//       "longitude": usermodel.longitude,
//       "captchaText": capchaText,
//       "captchaUniqueId": uniqueId,
//     };

//     String url = '$API_URL/signup';
//     Response response = await api.postHTTP(url, data);

//     if (response.statusCode == 200) {
//       UserModel result = UserModel.fromJson(response.data['data']);
//       context.goNamed('otpregister', extra: result);
//       return result;
//     } else {
//       String errorMessage = response.data['message'];
//       notifikasiFailed(errorMessage);
//       throw Exception('Failed to signup: $errorMessage');
//     }
//   }

//   Future<int> otpVerification(
//       String otpCode, String uniqueId, BuildContext context) async {
//     Map<String, dynamic> data = {
//       "uniqueId": uniqueId,
//       "otpCode": otpCode,
//     };
//     try {
//       String url = '$API_URL/otp-verification';
//       Response response = await api.postHTTP(url, data);
//       if (response.statusCode == 200) {
//         context.goNamed('successotp');
//         return response.statusCode!;
//       } else {
//         notifikasiFailed(response.data['message']);
//         return response.statusCode!;
//       }
//     } catch (e) {
//       rethrow; // Lemparkan kembali exception untuk penanganan lebih lanjut jika diperlukan
//     }
//   }

//   Future<Response> otpResend(
//       String otpCode, String uniqueId, BuildContext context) async {
//     Map<String, dynamic> data = {
//       "uniqueId": uniqueId,
//       "requestType": "OTP Email",
//       "otpCode": otpCode,
//     };
//     try {
//       String url = '$API_URL/otp-recreate';
//       Response response = await api.postHTTP(url, data);

//       if (response.statusCode == 200) {
//         notifikasiSuccess(response.data['message']);
//         return response;
//       } else {
//         notifikasiFailed(response.data['message']);
//         throw Exception('Failed to resend');
//       }
//     } catch (e) {
//       rethrow; // Lemparkan kembali exception untuk penanganan lebih lanjut jika diperlukan
//     }
//   }

//   Future<Response> createPIN(
//       {required String pin,
//       required double lat,
//       required double long,
//       required BuildContext context,
//       required String onRoute}) async {
//     Map<String, dynamic> data = {
//       "pin": pin,
//       "latitude": lat,
//       "longitude": long
//     };

//     try {
//       String url = '$API_URL/users/create-pin';
//       Response response = await api.postHTTP(url, data);

//       if (response.statusCode == 200) {
//         notifikasiSuccess(response.data['message']);
//         context.goNamed(onRoute);
//         return response;
//       } else {
//         // Tangani error jika status code bukan 200
//         notifikasiFailed(response.data['message']);
//         throw Exception('Failed to resend. Error: ${response.data['message']}');
//       }
//     } catch (e) {
//       rethrow; // Lemparkan kembali exception untuk penanganan lebih lanjut jika diperlukan
//     }
//   }

//   Future<void> forgotPassword(
//     String email,
//     context,
//     WidgetRef ref,
//   ) async {
//     String url = '$API_URL/req-forget-password';
//     Map<String, dynamic> data = {
//       "email": email,
//       "requestType": "OTP Email",
//       "source": "Lupa Password"
//     };
//     Response response = await api.postHTTP(url, data);

//     if (response.statusCode == 200) {
//       final data = response.data['data']['uniqueId'].toString();
//       if (data.isNotEmpty) {
//         notifikasiSuccess(response.data['message']);
//         ref.read(otpRequest.notifier).state = data;
//         GoRouter.of(context)
//             .goNamed('otpforgotpassword', queryParameters: {'email': email});
//       } else {
//         notifikasiFailed(response.data['message']);
//         GoRouter.of(context)
//             .goNamed('otpforgotpassword', queryParameters: {'email': email});
//       }
//     }
//   }

//   Future<int> forgotOtpVerifikasi(String otpCode, String uniqueId, String email,
//       BuildContext context) async {
//     Map<String, dynamic> data = {
//       "uniqueId": uniqueId,
//       "otpCode": otpCode,
//     };
//     try {
//       String url = '$API_URL/otp-verification';
//       Response response = await api.postHTTP(url, data);
//       if (response.statusCode == 200) {
//         context.goNamed('changepassword', queryParameters: {'email': email});
//         notifikasiSuccess(response.data['message']);
//         return response.statusCode!;
//       } else {
//         notifikasiFailed(response.data['message']);
//         return response.statusCode!;
//       }
//     } catch (e) {
//       rethrow; // Lemparkan kembali exception untuk penanganan lebih lanjut jika diperlukan
//     }
//   }

//   Future<int> changePassword(
//     String email,
//     String uniqueId,
//     String password,
//     BuildContext context,
//   ) async {
//     Map<String, dynamic> data = {
//       "email": email,
//       "uniqueId": uniqueId,
//       "password": password
//     };
//     String url = '$API_URL/reset-password';
//     Response response = await api.postHTTP(url, data);
//     if (response.statusCode == 200) {
//       context.goNamed('successpassword');
//       notifikasiSuccess(response.data['message']);
//       return response.statusCode!;
//     } else {
//       notifikasiFailed(response.data['message']);
//       return response.statusCode!;
//     }
//   }
}
