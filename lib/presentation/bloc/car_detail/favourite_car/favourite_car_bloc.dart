import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/datasources/car_detail_datasource.dart';
import 'package:motors_app/data/repositories/car_detail_repository.dart';

part 'favourite_car_event.dart';

part 'favourite_car_state.dart';

class FavouriteCarBloc extends Bloc<FavouriteCarEvent, FavouriteCarState> {
  FavouriteCarBloc() : super(InitialFavouriteCarState()) {
    on<AddToFavouriteEvent>((event, emit) async {
      emit(LoadingFavouriteCarState());

      try {
        final response = await _carDetailRepository.addToFavorite(
          event.carId,
          event.action,
        );

        if (response.data['code'] != 200) {
          emit(
            ErrorFavouriteCarState(
              event.action == FavouriteActions.add
                  ? false
                  : event.action == FavouriteActions.remove
                      ? true
                      : false,
              response.data['message'],
            ),
          );
        } else {
          emit(SuccessFavouriteCarState());
        }
      } catch (e, s) {
        logger.e('Error during with addToFavorite', error: e, stackTrace: s);
        emit(
          ErrorFavouriteCarState(
            event.action == FavouriteActions.add
                ? false
                : event.action == FavouriteActions.remove
                    ? true
                    : false,
            e.toString(),
          ),
        );
      }
    });
  }

  final _carDetailRepository = CarDetailRepositoryImpl();
}
