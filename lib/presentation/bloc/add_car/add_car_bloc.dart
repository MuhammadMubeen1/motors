import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/add_car/add_car_response.dart';
import 'package:motors_app/data/repositories/add_car_repository.dart';

part 'add_car_event.dart';

part 'add_car_state.dart';

class AddCarBloc extends Bloc<AddCarEvent, AddCarState> with ChangeNotifier {
  AddCarBloc() : super(InitialAddCarState()) {
    on<LoadAddCarParamsEvent>((event, emit) async {
      emit(InitialAddCarState());

      try {
        final AddCarResponse addCarResponse = await addCarRepository.getAddCarParams();

        emit(
          LoadedAddCarParamsState(
            addCarResponse: addCarResponse,
          ),
        );
      } catch (e, s) {
        logger.e('Error with getAddCarParams', error: e, stackTrace: s);
        emit(ErrorAddCarParamsState(e.toString()));
      }
    });

    on<AddCar>((event, emit) async {
      emit(LoadingAddCarState());

      try {
        final AddedCarResponse addedCarResponse = await addCarRepository.addCar(
          data: event.data,
        );

        if (addedCarResponse.code != 200) {
          emit(
            ErrorAddCarState(
              message: addedCarResponse.message,
              specificError: addedCarResponse.notSendRequiredFields,
            ),
          );
        } else {
          emit(
            SuccessAddedCarState(addedCarResponse: addedCarResponse),
          );
        }
      } catch (e, s) {
        logger.e('Error with add car', error: e, stackTrace: s);
        emit(ErrorAddCarState(message: e.toString()));
      }
    });

    on<UploadPhotoEvent>((event, emit) async {
      emit(LoadingUploadPhotoState());

      try {
        final response = await addCarRepository.uploadCarPhoto(
          data: event.data,
        );

        emit(SuccessUploadCarPhotoState(response: response));
      } catch (e, s) {
        logger.e('Error with upload photo', error: e, stackTrace: s);
        emit(ErrorUploadPhotoState(e.toString()));
      }
    });

    on<UpdateCarEvent>((event, emit) async {
      emit(LoadingEditCarState());

      try {
        final AddedCarResponse addedCarResponse = await addCarRepository.updateCar(
          data: event.data,
        );

        if (addedCarResponse.code != 200) {
          emit(
            ErrorAddCarState(
              message: addedCarResponse.message,
              specificError: addedCarResponse.notSendRequiredFields,
            ),
          );
        } else {
          emit(
            SuccessEditCarState(addedCarResponse: addedCarResponse),
          );
        }
      } catch (e, s) {
        logger.e('Error with edit car', error: e, stackTrace: s);
        emit(ErrorEditCarState(e.toString()));
      }
    });
  }

  AddCarRepository addCarRepository = AddCarRepositoryImpl();
}
