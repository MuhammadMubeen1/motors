import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/auth/restore_password_response.dart';
import 'package:motors_app/data/repositories/auth_repository.dart';

part 'restore_password_event.dart';

part 'restore_password_state.dart';

class RestorePasswordBloc extends Bloc<RestorePasswordEvent, RestorePasswordState> {
  RestorePasswordBloc() : super(InitialRestorePasswordState()) {
    on<ResetPasswordEvent>((event, emit) async {
      emit(LoadingRestorePasswordState());
      try {
        final response = await _authRepository.restorePassword(event.email);

        emit(SuccessRestorePasswordState(response));
      } catch (e, s) {
        logger.e('Error with restore password', error: e, stackTrace: s);
        emit(ErrorRestorePasswordState(e.toString()));
      }
    });
  }

  final _authRepository = AuthRepositoryImpl();
}
