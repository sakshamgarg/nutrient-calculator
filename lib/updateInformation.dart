import 'package:nutrient_calculator/autocomplete_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class UpdateInfo extends StatefulWidget {
  const UpdateInfo({Key? key}) : super(key: key);
  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32.0),
              child: TypeAheadField<FoodFromApi?>(
                hideSuggestionsOnKeyboardHide: false,
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    hintText: 'Search food item',
                  )
                ),
                suggestionsCallback: NutritionixApi.getFoodSuggestions,
                itemBuilder: (context, FoodFromApi? suggestion){
                  final food = suggestion!;
                  return ListTile(
                    title: Text(food.name),
                  );
                },
                noItemsFoundBuilder: (context)=> Container(
                  height: 100,
                  child: const Center(
                    child: Text(
                      'No food found',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                onSuggestionSelected: (FoodFromApi? suggestion){
                  final food = suggestion!;
                  _typeAheadController.text = food.name.toString();
                  ScaffoldMessenger.of(context)..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content:
                  Text('Selected food : ${food.name}')
                  ));
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {

                },
                child: Text('Submit'))
          ],
        ),
      ),
    );
  }
}
