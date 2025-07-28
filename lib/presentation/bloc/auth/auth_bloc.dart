import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/auth/auth_response.dart';
import 'package:motors_app/data/repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<SignInEvent>((event, emit) async {
      emit(LoadingSignInState());
      try {
        final AuthResponse authResponse = await _authRepository.signIn(event.login, event.password);

        if (authResponse.code != 200) {
          emit(ErrorSignInState(authResponse.message));
        } else {
          emit(SuccessSignInState());
        }
      } catch (e, s) {
        logger.e('Error with signIn', error: e, stackTrace: s);
        emit(ErrorSignInState(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(LoadingSignUpState());

      try {
        final AuthResponse authResponse = await _authRepository.signUp(
          event.login,
          event.name,
          event.surname,
          event.phone,
          event.email,
          event.password,
          event.avatar,
        );

        if (authResponse.code == 200) {
          emit(SuccessSignUpState());
        } else {
          emit(ErrorSignUpState(authResponse.message));
        }
      } catch (e) {
        emit(ErrorSignUpState(e.toString()));
      }
    });

    on<Logout>((event, emit) async => await preferences.remove(PreferencesName.apiToken));

    on<UpdateProfileEvent>((event, emit) async {
      emit(LoadingUpdateUserState());

      try {
        await _authRepository.updateProfile(
          event.userLogin,
          event.userName,
          event.userSurname,
          event.userPhone,
          event.userEmail,
          event.userPassword,
          event.userAvatar,
          event.userId,
          event.userToken,
        );

        emit(UpdatedUserState());
      } catch (e) {
        log('Error Update Profile Info: ${e}');
        emit(ErrorUpdateUserState(e.toString()));
      }
    });
  }

  final _authRepository = AuthRepositoryImpl();
}
