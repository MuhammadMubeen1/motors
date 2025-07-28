import 'package:flutter/foundation.dart';
import 'package:motors_app/data/models/place_search/place_search.dart';
import 'package:motors_app/data/repositories/add_car_repository.dart';

class AddCarProvider extends ChangeNotifier {
  final _addCarRepository = AddCarRepositoryImpl();
  PlaceSearchResponse? placeSearchResponse;

  // Map of add car
  final Map<String, dynamic> _addCarMap = {};

  // Map of add car image
  final Map<String, dynamic>? _addCarImageMap = {};

  bool _fieldIsEmpty = false;

  bool get fieldIsEmpty => _fieldIsEmpty;

  bool _isValidate = false;

  bool get isValidate => _isValidate;

  Map<String, dynamic> get addCarMap => _addCarMap;

  Map<String, dynamic>? get addCarImageMap => _addCarImageMap;

  void addCarParams({required String type, element}) {
    _addCarMap[type] = element;
    notifyListeners();
  }

  void addCarImageParams({required String type, element}) {
    _addCarImageMap?[type] = element;
    notifyListeners();
  }

  void removeCarParams({type}) {
    if (_addCarMap.containsKey(type)) {
      _addCarMap.remove(type);
      notifyListeners();
    }
  }

  void searchPlaces({search}) async {
    PlaceSearchResponse response = await _addCarRepository.searchPlaces(search: search);

    placeSearchResponse = response;

    notifyListeners();
  }

  void checkParamsValidate() {
    if (_addCarImageMap == null || _addCarImageMap.isEmpty) {
      _isValidate = true;
    }

    notifyListeners();
  }
}
