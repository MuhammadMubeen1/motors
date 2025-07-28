import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/datasources/car_detail_datasource.dart';
import 'package:motors_app/data/models/delete_car/delete_car_response.dart';
import 'package:motors_app/data/models/user/user_response.dart';
import 'package:motors_app/data/repositories/add_car_repository.dart';
import 'package:motors_app/data/repositories/auth_repository.dart';
import 'package:motors_app/data/repositories/car_detail_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(InitialProfileState()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(LoadingProfileState());
      try {
        final UserInfoResponse userInfo = await _authRepository.getUserInfo(int.parse(event.id!));

        emit(LoadedProfileState(userInfo));
      } catch (e, s) {
        logger.e('Error with load user info', error: e, stackTrace: s);
        emit(ErrorProfileState(e.toString()));
      }
    });

    on<DeleteCarEvent>((event, emit) async {
      emit(LoadingDeleteCarState());

      try {
        final response = await _addCarRepository.deleteCar(event.carId);

        if (response.status != 200) {
          emit(ErrorDeleteCarState(response.message ?? 'Error with delete car'));
        } else {
          emit(SuccessDeleteCarState(response: response));
        }
      } catch (e, s) {
        logger.e('Error with delete car ${event.carId}', error: e, stackTrace: s);
        emit(ErrorDeleteCarState(e.toString()));
      }
    });

    on<EditCarEvent>((event, emit) async {
      emit(LoadingEditCarState());
      try {
        final Map<String, dynamic> response = await _addCarRepository.getEditCarData(event.carId);

        emit(LoadedEditCarState(response: response));
      } catch (e, s) {
        logger.e('Error with edit car', error: e, stackTrace: s);
        emit(ErrorEditCarState(e.toString()));
      }
    });

    on<RemoveFavouriteCarEvent>((event, emit) async {
      emit(LoadingRemoveFromFavCarState());
      try {
        await _carDetailRepository.addToFavorite(
          event.carId,
          FavouriteActions.remove,
        );

        emit(SuccessRemoveFromFavCarState());
      } catch (e, s) {
        logger.e('Error with remove car from fav list', error: e, stackTrace: s);
        emit(ErrorRemoveFromFavCarState(e.toString()));
      }
    });
  }

  final AuthRepository _authRepository = AuthRepositoryImpl();
  final AddCarRepository _addCarRepository = AddCarRepositoryImpl();
  final CarDetailRepository _carDetailRepository = CarDetailRepositoryImpl();
}
