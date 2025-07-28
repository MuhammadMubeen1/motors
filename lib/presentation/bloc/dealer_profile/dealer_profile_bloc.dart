import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/dealer_user/dealer_user_response.dart';
import 'package:motors_app/data/repositories/car_detail_repository.dart';

part 'dealer_profile_event.dart';

part 'dealer_profile_state.dart';

class DealerProfileBloc extends Bloc<DealerProfileEvent, DealerProfileState> {
  DealerProfileBloc() : super(InitialDealerProfileState()) {
    on<LoadDealerProfileEvent>((event, emit) async {
      emit(InitialDealerProfileState());
      try {
        final DealerResponse dealerResponse = await _carDetailRepository.getDealerProfile(event.dealerId);

        emit(LoadedDealerProfileState(dealerResponse));
      } on DioException catch (e, s) {
        logger.e('Error during with getDealerProfile', error: e, stackTrace: s);
        emit(ErrorDealerProfileState());
      }
    });
  }

  final _carDetailRepository = CarDetailRepositoryImpl();
}
