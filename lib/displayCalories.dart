import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';



class DisplayCalories extends StatefulWidget {
  File? foodImage;
  Category? category;

  DisplayCalories(File? image, Category? category, {super.key}){
    this.foodImage = image;
    this.category = category;
  }

  // const DisplayCalories({Key? key}) : super(key: key);

  @override
  State<DisplayCalories> createState() => _DisplayCaloriesState();
}

final List<Image> myImages = [
  Image(
    image: AssetImage('images/donuts.jpg'),
    fit: BoxFit.cover,
  )
];

class _DisplayCaloriesState extends State<DisplayCalories> {

  late List<charts.Series<dynamic, String>> seriesList;

  static List<charts.Series<Nutrients, String>> _createRandomData(){
    final random = Random();
    final nutriData = [
      Nutrients("Carbs", random.nextInt(20)),
      Nutrients("Fats", random.nextInt(20)),
      Nutrients("Protein", random.nextInt(20)),
      Nutrients("Calories", random.nextInt(20)),
    ];

    return [charts.Series<Nutrients, String>(
      id: 'Nutrients',
      domainFn: (Nutrients nutrient, _) => nutrient.nutrientType,
      measureFn: (Nutrients nutri, _) => nutri.weight,
      data: nutriData,
    )];

  }

  @override
  void initState() {
    super.initState();
    final directory = getApplicationDocumentsDirectory();
    seriesList = _createRandomData();
  }

  barChart(){
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Food calories'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // GridView.count(
            //     crossAxisCount: 1,
            //     children: [...myImages]
            // ),
            Container(
              // padding: EdgeInsets.all(20.0),
              child: barChart(),
            ),
          ],
        ),
      ),
    );


    // return MaterialApp(
    //   title: 'Diet Vision',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: Scaffold(
    //     body: Column(
    //       children: [
    //         GridView.count(
    //           crossAxisCount: 1,
    //           children: [...myImages]
    //         ),
    //         Container(
    //           padding: EdgeInsets.all(20.0),
    //           child: barChart(),
    //         ),
    //       ],
    //     )
    //   ),
    // );
  }
}

class Nutrients{
  final String nutrientType;
  final int weight;

  Nutrients(this.nutrientType, this.weight);
}