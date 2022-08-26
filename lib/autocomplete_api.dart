import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodFromApi {
  final String name;

  const FoodFromApi({
    required this.name,
  });

  static FoodFromApi fromJson(Map<String, dynamic> json) => FoodFromApi(
      name: json['text']
  );
}

class NutritionixApi {
  static Future<List<FoodFromApi>> getFoodSuggestions(String query) async {
    // final url = Uri.parse('https://api.nutritionix.com/v2/autocomplete');
    final url = Uri.https('api.nutritionix.com', '/v2/autocomplete',{"q":query});
    var headers = {
      'x-app-id':'2ee6074c',
      'x-app-key':'347814e92761f830d05ee2787cbf1db2',
    };
    final response = await http.get(url,headers: headers);

    if (response.statusCode == 200) {
      final List foods = json.decode(response.body);
      return foods.map((json) => FoodFromApi.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}
