import 'package:json_annotation/json_annotation.dart';

part 'filter_response.g.dart';

@JsonSerializable()
class Filter {
  Filter({
    this.condition,
    this.body,
    this.make,
    this.serie,
    this.mileage,
    this.fuel,
    this.engine,
    this.year,
    this.price,
    this.fuelConsumption,
    this.transmission,
    this.drive,
    this.fuelEconomy,
    this.exteriorColor,
    this.interiorColor,
    this.searchRadius,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  final dynamic condition;
  final dynamic body;
  final dynamic make;
  final dynamic serie;
  final dynamic mileage;
  final dynamic fuel;
  final dynamic engine;
  final dynamic year;
  final dynamic price;
  final dynamic fuelConsumption;
  final dynamic transmission;
  final dynamic drive;
  final dynamic fuelEconomy;
  final dynamic exteriorColor;
  final dynamic interiorColor;
  final dynamic searchRadius;

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
