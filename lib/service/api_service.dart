import 'dart:convert';
import 'dart:developer';
import 'package:akpa/model/confgmodel/config_model.dart';
import 'package:akpa/model/deathmodel/death_model.dart';
import 'package:akpa/model/edit_profile_main_app/edit_profile.dart';
import 'package:akpa/model/helpmodel/help_model.dart';
import 'package:akpa/model/loginmodel/login_model.dart';
import 'package:akpa/model/reset_password/reset_password_model.dart';
import 'package:akpa/model/transactionmodel/transaction_model.dart';
import 'package:akpa/model/usermodel/user_model.dart';
import 'package:akpa/service/store_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://akpa.in/santhwanam/api/v1/';
  final Dio _dio = Dio();

  Future<Config> fetchConfig() async {
    final response = await _dio.get('https://akpa.in/santhwanam/api/v1/config');
    if (response.statusCode == 200) {
      return Config.fromJson(response.data);
    } else {
      throw Exception('Failed to load config');
    }
  }

  //---login---Service---//



  Future<LoginModel?> login(String phone, String password) async {
    const url = "https://akpa.in/Controller_api/login_api";

    var headers = {
      'Cookie': 'ci_session=7fpn0r4msvv14r495qbcm4c9sseuca9v',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      log('Attempting to log in with phone: $phone');

      final response = await _dio.post(
        url,
        data: {
          'phone': phone,
          'password': password,
        },
        options: Options(headers: headers),
      );

      log('Response status code: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        var data = response.data;
        data = jsonDecode(data);

        if (data is Map<String, dynamic>) {
          if (data['status'] == true) {
            if (data['data'] is Map<String, dynamic>) {
              final loginModel = LoginModel.fromMap(data['data']);

              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (loginModel.memberId != null) {
                await StoreService.setLoginUserId(
                    loginModel.memberId!.toString());
                await prefs.setString(
                    'member_id', loginModel.memberId!.toString());

                print("Saved Member Id : ${loginModel.memberId} ");
              }

              return loginModel;
            } else {
              log('Expected data to be a Map, but got: ${data['data']}');
              return null;
            }
          } else {
            log('Login failed with message: ${data['message']}');
            print('Login failed: ${data['message']}');
            return null;
          }
        } else {
          log('Expected response to be a Map, but got: $data');
          return null;
        }
      } else {
        log('Login failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Login failed with error: $e');
      return null;
    }
  }

  Future<void> updateDeviceToken(String username) async {
    final url = "${baseUrl}user/update_device_token";

    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final deviceToken = sharedPreferences.getString('deviceToken') ?? '';

      await _dio.post(
        url,
        data: {
          'username': username,
          'deviceToken': deviceToken,
        },
      );
    } catch (e) {
      log('Failed to update device token: $e');
    }
  }

  Future<void> logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove('username');
    await sharedPreferences.remove('password');

    final url = "${baseUrl}user/remove_device_token";
    final deviceToken = sharedPreferences.getString('deviceToken') ?? '';

    try {
      await _dio.post(
        url,
        data: {
          'deviceToken': deviceToken,
        },
      );
    } catch (e) {
      log('Failed to remove device token: $e');
    }
  }

  //---user---view--//

  Future<UserProfile> getUserProfile() async {
    final url = 'https://akpa.in/Controller_api/profile';
    try {
      var userId = await StoreService.getLoginUserId();

      if (userId == null || userId.isEmpty) {
        log('userId is null or empty, cannot fetch user profile');
        throw Exception('userId is null or empty');
      }

      log('Retrieved userId: $userId');

      FormData formData = FormData.fromMap({
        'user_id': userId,
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Cookie': 'ci_session=1f9imu6f2t5cudqp8amnlt967mejr2lk',
          },
        ),
      );

      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        var data = response.data;
        data = jsonDecode(data);

        if (data is Map<String, dynamic>) {
          return UserProfile.fromJson(data);
        } else {
          print('AAAAAjjfjsbfj');
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception(
            'Failed to fetch user profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to fetch user profile with error: $e');
      throw Exception('Failed to fetch user profile');
    }
  }



  Future<Config> getConfig() async {
    const url = 'https://akpa.in/Controller_api/app_config';

    try {
      final response = await _dio.get(url);

      print('aaaaAAAAAAAAA');
      print('Config API Response: ${response.data}');

      if (response.statusCode == 200) {
        print('aMMMMMMMMMMM');
        final decodedResponse = response.data is String
            ? json.decode(response.data)
            : response.data; // Already a Map

        return Config.fromJson(decodedResponse['data']);
      } else {
        throw Exception('Failed to load configuration');
      }
    } catch (e) {
      log('Error fetching config: $e');
      rethrow;
    }
  }

  //---dashboard--//
  // Future<UserProfile?> getDashboard() async {
  //   try {
  //     final response = await _dio.post(
  //       'https://akpa.in/santhwanam/api/v1/user/dashboard',
  //     );
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.data);
  //       return UserProfile.fromJson(data['member_details']);
  //     } else {
  //       throw Exception('Failed to load user profile');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load user profile: $e');
  //   }
  // }

  //--transaction---//
  Future<List<Transaction>> getTransactionList() async {
    const String url = 'https://akpa.in/santhwanam/api/v1/user/transactions';

    final memberId = await StoreService.getLoginUserId();
    try {
      final response = await _dio.post(
        url,
        data: {'member_id': memberId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['list']['data'];
        return data.map((item) => Transaction.fromJson(item)).toList();
      } else {
        log('Error: ${response.statusCode}');
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Failed to load transactions: $e');
    }
  }

  //---help--list---//

  Future<HelpModel> getUserList() async {
    try {
      final memberId = await StoreService.getLoginUserId();
      final response = await Dio().post(
        'https://akpa.in/santhwanam/api/v1/user/help_list',
        data: {'user_id': memberId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        log('response${response.data}');
        return HelpModel.fromMap(response.data);
      } else {
        log('service help');
        return HelpModel(list: ListClass(data: []));
      }
    } catch (e) {
      log('Error service: $e');
      throw Exception('Failed to fetch help list');
    }
  }

  Future<List<DeathDetail>> fetchDeathDetails() async {
    try {
      final memberId = await StoreService.getLoginUserId();
      final response = await _dio
          .post('https://akpa.in/santhwanam/api/v1/user/death_list', data: {
        'member_id': memberId,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['list']['data'];
        return data.map((json) => DeathDetail.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load death details');
      }
    } catch (e) {
      throw Exception('Error fetching death details: $e');
    }
  }

  Future<Map<String, dynamic>> editUserProfile(
      ProfileUpdateModel profileUpdate) async {
    var headers = {'Cookie': 'ci_session=9c58vvrqfamed8nqvfrnocnd9q76baa9'};

    var data = FormData.fromMap({
      'user_id': profileUpdate.userId,
      'name': profileUpdate.name,
      'email': profileUpdate.email,
      'mobile': profileUpdate.mobile,
      'whatsapp_number': profileUpdate.whatsappNumber,
      'address': profileUpdate.address,
      'pincode': profileUpdate.pincode,
      'nominee_name': profileUpdate.nomineeName,
    });

    try {
      var response = await _dio.post(
        'https://akpa.in/Controller_api/edit_profile',
        options: Options(headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        return json.decode(response.data);
      } else {
        print('Error response: ${response.data}');
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');

      if (e is DioException) {
        print('Dio error: ${e.response?.data}');
        throw Exception('Dio error: ${e.response?.data}');
      }
      throw e;
    }
  }

    //---Reset_Password---Service---//

  Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest model) async {
    try {
      final formData = FormData.fromMap(model.toMap());
      final response = await _dio.post(
        'https://akpa.in/Controller_api/reset_password',
        data: formData,
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          return ResetPasswordResponse.fromJson(response.data);
        } else {
          return ResetPasswordResponse.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
