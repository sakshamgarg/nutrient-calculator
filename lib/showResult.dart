import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';


/*  ----------------------     */

// To parse this JSON data, do
//
//     final foodNutrients = foodNutrientsFromJson(jsonString);

// FoodNutrients foodNutrientsFromJson(String str) => FoodNutrients.fromJson(json.decode(str));

String foodNutrientsToJson(FoodNutrients data) => json.encode(data.toJson());

class FoodNutrients {
  FoodNutrients({
    required this.foods,
  });

  List<Food> foods;

  factory FoodNutrients.fromJson(Map<String, dynamic> json) => FoodNutrients(
    foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
  };
}

class Food {
  Food({
    required this.foodName,
    this.brandName,
    required this.servingQty,
    required this.servingUnit,
    required this.servingWeightGrams,
    required this.nfCalories,
    required this.nfTotalFat,
    required this.nfSaturatedFat,
    required this.nfCholesterol,
    required this.nfSodium,
    required this.nfTotalCarbohydrate,
    required this.nfDietaryFiber,
    required this.nfSugars,
    required this.nfProtein,
    required this.nfPotassium,
    required this.nfP,
    required this.fullNutrients,
    this.nixBrandName,
    this.nixBrandId,
    this.nixItemName,
    this.nixItemId,
    this.upc,
    required this.consumedAt,
    required this.metadata,
    required this.source,
    required this.ndbNo,
    required this.tags,
    required this.altMeasures,
    this.lat,
    this.lng,
    required this.mealType,
    required this.photo,
    this.subRecipe,
    this.classCode,
    this.brickCode,
    this.tagId,
  });

  String foodName;
  dynamic brandName;
  int servingQty;
  String servingUnit;
  double servingWeightGrams;
  double nfCalories;
  double nfTotalFat;
  double nfSaturatedFat;
  double nfCholesterol;
  double nfSodium;
  double nfTotalCarbohydrate;
  double nfDietaryFiber;
  double nfSugars;
  double nfProtein;
  double nfPotassium;
  double nfP;
  List<FullNutrient> fullNutrients;
  dynamic nixBrandName;
  dynamic nixBrandId;
  dynamic nixItemName;
  dynamic nixItemId;
  dynamic upc;
  DateTime consumedAt;
  Metadata metadata;
  int source;
  int ndbNo;
  Tags tags;
  List<AltMeasure> altMeasures;
  dynamic lat;
  dynamic lng;
  int mealType;
  Photo photo;
  dynamic subRecipe;
  dynamic classCode;
  dynamic brickCode;
  dynamic tagId;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    foodName: json["food_name"],
    brandName: json["brand_name"],
    servingQty: json["serving_qty"],
    servingUnit: json["serving_unit"],
    servingWeightGrams: json["serving_weight_grams"].toDouble(),
    nfCalories: json["nf_calories"].toDouble(),
    nfTotalFat: json["nf_total_fat"].toDouble(),
    nfSaturatedFat: json["nf_saturated_fat"].toDouble(),
    nfCholesterol: json["nf_cholesterol"].toDouble(),
    nfSodium: json["nf_sodium"].toDouble(),
    nfTotalCarbohydrate: json["nf_total_carbohydrate"].toDouble(),
    nfDietaryFiber: json["nf_dietary_fiber"].toDouble(),
    nfSugars: json["nf_sugars"].toDouble(),
    nfProtein: json["nf_protein"].toDouble(),
    nfPotassium: json["nf_potassium"].toDouble(),
    nfP: json["nf_p"].toDouble(),
    fullNutrients: List<FullNutrient>.from(json["full_nutrients"].map((x) => FullNutrient.fromJson(x))),
    nixBrandName: json["nix_brand_name"],
    nixBrandId: json["nix_brand_id"],
    nixItemName: json["nix_item_name"],
    nixItemId: json["nix_item_id"],
    upc: json["upc"],
    consumedAt: DateTime.parse(json["consumed_at"]),
    metadata: Metadata.fromJson(json["metadata"]),
    source: json["source"],
    ndbNo: json["ndb_no"],
    tags: Tags.fromJson(json["tags"]),
    altMeasures: List<AltMeasure>.from(json["alt_measures"].map((x) => AltMeasure.fromJson(x))),
    lat: json["lat"],
    lng: json["lng"],
    mealType: json["meal_type"],
    photo: Photo.fromJson(json["photo"]),
    subRecipe: json["sub_recipe"],
    classCode: json["class_code"],
    brickCode: json["brick_code"],
    tagId: json["tag_id"],
  );

  Map<String, dynamic> toJson() => {
    "food_name": foodName,
    "brand_name": brandName,
    "serving_qty": servingQty,
    "serving_unit": servingUnit,
    "serving_weight_grams": servingWeightGrams,
    "nf_calories": nfCalories,
    "nf_total_fat": nfTotalFat,
    "nf_saturated_fat": nfSaturatedFat,
    "nf_cholesterol": nfCholesterol,
    "nf_sodium": nfSodium,
    "nf_total_carbohydrate": nfTotalCarbohydrate,
    "nf_dietary_fiber": nfDietaryFiber,
    "nf_sugars": nfSugars,
    "nf_protein": nfProtein,
    "nf_potassium": nfPotassium,
    "nf_p": nfP,
    "full_nutrients": List<dynamic>.from(fullNutrients.map((x) => x.toJson())),
    "nix_brand_name": nixBrandName,
    "nix_brand_id": nixBrandId,
    "nix_item_name": nixItemName,
    "nix_item_id": nixItemId,
    "upc": upc,
    "consumed_at": consumedAt.toIso8601String(),
    "metadata": metadata.toJson(),
    "source": source,
    "ndb_no": ndbNo,
    "tags": tags.toJson(),
    "alt_measures": List<dynamic>.from(altMeasures.map((x) => x.toJson())),
    "lat": lat,
    "lng": lng,
    "meal_type": mealType,
    "photo": photo.toJson(),
    "sub_recipe": subRecipe,
    "class_code": classCode,
    "brick_code": brickCode,
    "tag_id": tagId,
  };
}

class AltMeasure {
  AltMeasure({
    required this.servingWeight,
    required this.measure,
    required this.seq,
    required this.qty,
  });

  double servingWeight;
  String measure;
  var seq;
  int qty;

  factory AltMeasure.fromJson(Map<String, dynamic> json) => AltMeasure(
    servingWeight: json["serving_weight"].toDouble(),
    measure: json["measure"],
    seq: json["seq"] == null ? null : json["seq"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "serving_weight": servingWeight,
    "measure": measure,
    "seq": seq == null ? null : seq,
    "qty": qty,
  };
}

class FullNutrient {
  FullNutrient({
    required this.attrId,
    required this.value,
  });

  int attrId;
  double value;

  factory FullNutrient.fromJson(Map<String, dynamic> json) => FullNutrient(
    attrId: json["attr_id"],
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "attr_id": attrId,
    "value": value,
  };
}

class Metadata {
  Metadata({
    required this.isRawFood,
  });

  bool isRawFood;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    isRawFood: json["is_raw_food"],
  );

  Map<String, dynamic> toJson() => {
    "is_raw_food": isRawFood,
  };
}

class Photo {
  Photo({
    required this.thumb,
    required this.highres,
    required this.isUserUploaded,
  });

  String thumb;
  String highres;
  bool isUserUploaded;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    thumb: json["thumb"],
    highres: json["highres"],
    isUserUploaded: json["is_user_uploaded"],
  );

  Map<String, dynamic> toJson() => {
    "thumb": thumb,
    "highres": highres,
    "is_user_uploaded": isUserUploaded,
  };
}

class Tags {
  Tags({
    required this.item,
    this.measure,
    required this.quantity,
    required this.foodGroup,
    required this.tagId,
  });

  String item;
  dynamic measure;
  String quantity;
  int foodGroup;
  int tagId;

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
    item: json["item"],
    measure: json["measure"],
    quantity: json["quantity"],
    foodGroup: json["food_group"],
    tagId: json["tag_id"],
  );

  Map<String, dynamic> toJson() => {
    "item": item,
    "measure": measure,
    "quantity": quantity,
    "food_group": foodGroup,
    "tag_id": tagId,
  };
}


/*  ----------------------    */


Future<FoodNutrients> fetchNutrients(var query) async {
  // final response = await http
  //     .get(Uri.parse('https://api.nutritionix.com/v1_1/search/cheddar%20cheese?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=[2ee6074c]&appKey=[878305796a4ab0c04af76d89c942f619]'));
  print("FINAL FOOD CLASS IS:");
  print(query.toString());
  query ??= "for breakfast i ate 2 eggs, bacon, and french toast"; // Testing for null
  Map queryData = {
    "query": query.toString(),
    "timezone": "US/Eastern"
  };
  var queryBody = json.encode(queryData);
  final response = await http.
  post(Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients'),
      headers: {'Content-type': 'application/json', 'x-app-id':'2ee6074c','x-app-key':'347814e92761f830d05ee2787cbf1db2'},
      body: queryBody);
  // print(response);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // return Album.fromJson(jsonDecode(response.body));
    return FoodNutrients.fromJson(json.decode(response.body));
    // return Album.fromJson(json.decode(response.body));
  }
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to find given Food');
  }
}


class ShowResult extends StatefulWidget {
  final File? foodImage;
  final String foodName;

  ShowResult({Key? key, required this.foodImage, required this.foodName}) : super(key: key);

  @override
  State<ShowResult> createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  late Future<FoodNutrients> futureNutrients;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("RECEIVED LABEL");
    print(widget.foodName);
    futureNutrients = fetchNutrients(widget.foodName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Nutrients',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Display the result
              widget.foodImage != null ?
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  // image: Image.file(widget.foodImage!),
                  // fit: BoxFit.fitWidth
                  // )
                ),
                child: Image.file(widget.foodImage!),
              ) :
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/demoImage.png'),
                        fit: BoxFit.fitWidth
                    )
                ),
                // child: Image.asset('images/demoImage.png'),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  // color : Color.fromRGBO(255, 255, 255, 1),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                        child: FutureBuilder<FoodNutrients>(future: futureNutrients, builder: (context, snapshot){
                          if (snapshot.hasData){
                            return Text(
                                "Food name : ${snapshot.data!.foods[0].foodName}\n\n"
                                    "Calorie : ${snapshot.data!.foods[0].nfCalories}\n"
                                    "Total Fat : ${snapshot.data!.foods[0].nfTotalFat.toString()}\n"
                                    "Protein : ${snapshot.data!.foods[0].nfProtein.toString()}\n"
                                "Carbs : ${snapshot.data!.foods[0].nfTotalCarbohydrate.toString()}\n"
                                "Fibre : ${snapshot.data!.foods[0].nfDietaryFiber.toString()}\n"
                                "Sugar : ${snapshot.data!.foods[0].nfSugars.toString()}\n",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: 22,
                                      height: 1,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,)
                                )
                            );
                          } else if (snapshot.hasError){
                            print(snapshot.error);
                            print("RETURNING ERROR");
                            // return Text('${snapshot.error}');
                            return Text('Cannot Find Appropriate Nutrients of the food');
                          }
                          return const CircularProgressIndicator();
                        }),
                      ),
                    ],
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
