import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/data/repositories/car_detail_repository.dart';

part 'car_detail_event.dart';
part 'car_detail_state.dart';

class CarDetailBloc extends Bloc<CarDetailEvent, CarDetailState> {
  CarDetailBloc() : super(InitialCarDetailState()) {
    on<CarDetailLoadEvent>((event, emit) async {
      emit(LoadingCarDetailState());

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 100)),
        'assets/images/location_mark.png',
      );

      try {
        final carDetailResponse = await _carDetailRepository.getCarDetail(
          id: event.id,
          userId: event.userId,
        );

        double latitude;
        double longitude;

        if (carDetailResponse.carLat.isNotEmpty &&
            carDetailResponse.carLng.isNotEmpty) {
          latitude = double.parse(carDetailResponse.carLat);
          longitude = double.parse(carDetailResponse.carLng);
        } else {
          latitude = 37.42796133580664;
          longitude = -122.085749655962;
        }

        Set<Marker> markers = {};
        markers.add(
          Marker(
            markerId: MarkerId(carDetailResponse.carLocation),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: carDetailResponse.carLocation,
            ),
            icon: markerbitmap,
          ),
        );

        emit(
          LoadedCarDetailState(
            loadedDetailCar: carDetailResponse,
            latitude: latitude,
            longitude: longitude,
            marker: markers,
          ),
        );
      } catch (e, s) {
        logger.e('Error during with getCarDetail', error: e, stackTrace: s);
        emit(ErrorCarDetailState(e.toString()));
      }
    });
  }

  final _carDetailRepository = CarDetailRepositoryImpl();
}
