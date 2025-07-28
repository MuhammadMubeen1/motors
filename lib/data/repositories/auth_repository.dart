import 'dart:io';

import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/datasources/auth_datasource.dart';
import 'package:motors_app/data/models/auth/auth_response.dart';
import 'package:motors_app/data/models/auth/restore_password_response.dart';
import 'package:motors_app/data/models/user/user_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn(String login, String password);

  Future<AuthResponse> signUp(login, name, surname, phone, email, password, File? avatar);

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

  Future logout();
}

class AuthRepositoryImpl extends AuthRepository {
  final _authDataSource = AuthRemoteDataSource();

  @override
  Future<AuthResponse> signIn(login, password) async {
    final AuthResponse authResponse = await _authDataSource.signIn(login, password);

    if (authResponse.code == 200) {
      await preferences.setString(PreferencesName.password, password);
      if (authResponse.user?.token != null) {
        await preferences.setString(PreferencesName.apiToken, authResponse.user!.token!);
      }
      if (authResponse.user?.ID != null) {
        await preferences.setString(PreferencesName.userId, authResponse.user!.ID);
      }
    } else {
      await preferences.remove(PreferencesName.apiToken);
    }

    return authResponse;
  }

  @override
  Future<AuthResponse> signUp(login, name, surname, phone, email, password, File? avatar) async {
    AuthResponse authResponse = await _authDataSource.signUp(login, name, surname, phone, email, password, avatar,)  ;

    if (authResponse.code == 200) {
      await preferences.setString(PreferencesName.password, password);
      if (authResponse.user?.token != null) {
        await preferences.setString(PreferencesName.apiToken, authResponse.user!.token!);
      }
      if (authResponse.user?.ID != null) {
        await preferences.setString(PreferencesName.userId, authResponse.user!.ID);
      }
    } else {
      await preferences.remove(PreferencesName.apiToken);
      await preferences.remove(PreferencesName.userId);
      await preferences.remove(PreferencesName.password);
    }

    return authResponse;
  }

  @override
  Future logout() async {
    await preferences.remove(PreferencesName.apiToken);
    await preferences.remove(PreferencesName.userId);
    await preferences.remove(PreferencesName.password);
  }

  @override
  Future<UserInfoResponse> getUserInfo(int? id) async => await _authDataSource.getUserInfo(id);

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
    final response = await _authDataSource.updateProfile(
      userLogin,
      userName,
      userSurname,
      userPhone,
      userEmail,
      userPassword,
      userAvatar,
      userId,
      userToken,
    );

    return response;
  }

  @override
  Future<RestorePasswordResponse> restorePassword(String email) async => _authDataSource.restorePassword(email);
}
