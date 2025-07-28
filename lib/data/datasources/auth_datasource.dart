import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/data/models/auth/auth_response.dart';
import 'package:motors_app/data/models/auth/restore_password_response.dart';
import 'package:motors_app/data/models/user/user_response.dart';

abstract class AuthDataSource {
  Future<AuthResponse> signIn(String login, String password);

  Future<AuthResponse> signUp(
      login, name, surname, phone, email, password, File? avatar);

  Future<RestorePasswordResponse> restorePassword(String email);

  Future<UserInfoResponse> getUserInfo(int? id);

  Future updateProfile(
    String userLogin,
    String? userName,
    String? userSurname,
    String userPhone,
    String userEmail,
    String userPassword,
    File? userAvatar,
    String userId,
    String? userToken,
  );
}

class AuthRemoteDataSource implements AuthDataSource {
  final HttpService _httpService = HttpService();
  


  @override
  Future<AuthResponse> signIn(login, password) async {
    try {
      final response = await _httpService.dio.post(
        '/login',
        data: {
          'stm_login': login,
          'stm_pass': password,
        },
        options: Options(
          headers: {'content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      print('SignIn Response: ${response.data}');
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('SignIn Error: ${e.toString()}');
      throw Exception();
    }
  }

  @override
 @override
  Future<AuthResponse> signUp(dynamic login, dynamic name, dynamic surname,
      dynamic phone, dynamic email, dynamic password, File? avatar) async {
    Uint8List? bytesImg;

    if (avatar != null) {
      bytesImg = await avatar.readAsBytes();
    }

    final Map<String, dynamic> data = {
      'stm_nickname': login.trim(),
      'stm_user_first_name': (name ?? '').trim(),
      'stm_user_last_name': (surname ?? '').trim(),
      'stm_user_phone': phone.trim(),
      'stm_user_mail': email.trim(),
      'stm_user_password': password,
      'avatar': bytesImg == null ? '' : base64.encode(bytesImg),
    };

    try {
      final response = await _httpService.dio.post(
        '/registration',
        data: data,
        options: Options(
          headers: {'content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      print('✅ SignUp Response: ${response.data}');

      if (response.data['success'] == true &&
          response.data['user_id'] != null) {
        preferences.setString(
          PreferencesName.userId,
          response.data['user_id'].toString(),
        );

        Fluttertoast.showToast(
            msg: "User signed up successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
  
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? "Registration failed");
      }
    } on DioException catch (e) {
      String errorMessage = "An error occurred";

      if (e.response?.statusCode == 409) {
        errorMessage = "User already exists";
      } else if (e.response?.statusCode == 500) {
        errorMessage = "Server error, please try again later";
      } else {
        errorMessage = e.response?.data['message'] ?? e.message ?? errorMessage;
      }

      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      throw Exception(errorMessage);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An unexpected error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      throw Exception("An unexpected error occurred");
    }
  }
  @override
  Future<UserInfoResponse> getUserInfo(int? id) async {
    try {
      final response = await _httpService.dio.get('/private-user/$id');

      print('GetUserInfo Response: ${response.data}');
      return UserInfoResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('GetUserInfo Error: ${e.response}');
      throw Exception(e.response);
    }
  }

  @override
  Future updateProfile(
    String userLogin,
    String? userName,
    String? userSurname,
    String userPhone,
    String userEmail,
    String userPassword,
    File? userAvatar,
    String userId,
    String? userToken,
  ) async {
    Uint8List? bytesImg;

    if (userAvatar != null) {
      bytesImg = userAvatar.readAsBytesSync();
    } else {
      bytesImg = null;
    }

    // Print each field individually
    print('UpdateProfile Data:');
    print('stm_nickname: $userLogin');
    print('stm_user_first_name: ${userName ?? ''}');
    print('stm_user_last_name: ${userSurname ?? ''}');
    print('stm_user_phone: $userPhone');
    print('stm_user_mail: $userEmail');
    print('stm_user_password: $userPassword');
    print('userId: $userId');
    print('userToken: $userToken');
    print(
        'avatar: ${bytesImg == null ? 'null' : 'image bytes (length: ${bytesImg.length})'}');

    Map<String, dynamic> data = {
      'stm_nickname': userLogin,
      'stm_user_first_name': userName ?? '',
      'stm_user_last_name': userSurname ?? '',
      'stm_user_phone': userPhone,
      'stm_user_mail': userEmail,
      'stm_user_password': userPassword,
      'userId': userId,
      'userToken': userToken,
      'avatar': bytesImg == null ? '' : base64.encode(bytesImg),
    };

    try {
      final response = await _httpService.dio.post(
        '/update-profile',
        options: Options(
          headers: {'content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: data,
      );

      print('UpdateProfile Response: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('UpdateProfile Error: ${e.response}');
      throw Exception(e.response);
    }
  }

  @override
  Future<RestorePasswordResponse> restorePassword(String email) async {
    try {
      final response = await _httpService.dio.post(
        '/lost-password',
        options: Options(
          headers: {'content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'stm_user_login': email,
        },
      );

      print('RestorePassword Response: ${response.data}');
      return RestorePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('RestorePassword Error: ${e.response}');
      throw Exception(e.response);
    }
  }
  
}
