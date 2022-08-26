import 'dart:ffi';

class Food {
  final String foodClass;
  final double volume;

  const Food({
    required this.foodClass,
    required this.volume
  });

  Food copy({
    String? foodClass,
    double? volume,
  }) =>
      Food(
        foodClass: foodClass ?? this.foodClass,
        volume: volume ?? this.volume,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Food &&
              runtimeType == other.runtimeType &&
              foodClass == other.foodClass &&
              volume == other.volume;

  @override
  int get hashCode => foodClass.hashCode ^ volume.hashCode ;
}
