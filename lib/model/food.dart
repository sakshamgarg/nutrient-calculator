import 'dart:ffi';

class FoodDetails {
  final String foodClass;
  final double volume;

  const FoodDetails({
    required this.foodClass,
    required this.volume
  });

  FoodDetails copy({
    String? foodClass,
    double? volume,
  }) =>
      FoodDetails(
        foodClass: foodClass ?? this.foodClass,
        volume: volume ?? this.volume,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FoodDetails &&
              runtimeType == other.runtimeType &&
              foodClass == other.foodClass &&
              volume == other.volume;

  @override
  int get hashCode => foodClass.hashCode ^ volume.hashCode ;
}
