
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nutrient_calculator/widget/scrollable_widget.dart';
import 'package:nutrient_calculator/widget/text_dialog_widget.dart';
import 'package:nutrient_calculator/model/food.dart';
import 'package:nutrient_calculator/data/foodexample.dart';
import 'package:nutrient_calculator/utils.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'displayCalories.dart';
import 'package:nutrient_calculator/showResult.dart';


class ConfirmClasses extends StatefulWidget {
  // const ConfirmClasses({Key? key}) : super(key: key);

  File? foodImage;
  // Category? category;
  String? finalFood;
  String? finalScore;

  ConfirmClasses(File? image, String? foodName, String? score, {super.key}){
    this.foodImage = image;
    // this.category = category;
    this.finalFood = foodName;
    this.finalScore = score;
  }

  @override
  State<ConfirmClasses> createState() => _ConfirmClassesState();
}

final List<Image> myImages = [
  Image(
    image: AssetImage('images/donuts.jpg'),
    fit: BoxFit.cover,
  ),
  Image(
    image: AssetImage('images/Chicken-Pad-Thai.jpg'),
    fit: BoxFit.cover,
  ),
];

class _ConfirmClassesState extends State<ConfirmClasses> {

  File? image;
  // Category? category;
  late List<FoodDetails> allFoods;
  final columns = ['Food Class', 'Confidence Level'];
  String? finalFoodName;
  String? finalConfidenceScore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final foodResult = <FoodDetails>[
      FoodDetails(foodClass: widget.finalFood!, volume: widget.finalScore!),
    ];
    widget.finalFood != "" ?
    this.allFoods = List.of(foodResult) : this.allFoods = List.of(exampleFood);
    this.image = widget.foodImage;
    // this.category = widget.category;
    this.finalFoodName = widget.finalFood;
    this.finalConfidenceScore = widget.finalScore;
  }

  Future editFoodClass(FoodDetails editfood) async{
    final newfoodname = await showTextDialog(
        context,
        title: 'Change food class',
        value: editfood.foodClass
    );

    setState(() => allFoods = allFoods.map((food) {
      final isEditFood = food == editfood;
      finalFoodName = newfoodname;
      return isEditFood ? food.copy(foodClass: newfoodname) : food;
    }).toList());
  }

  Future editVolume(FoodDetails editvol) async{
    final newvolume = await showTextDialog(
        context,
        title: 'Change food volume',
        value: editvol.volume.toString()
    );

    setState(() => allFoods = allFoods.map((food) {
      final isEditVol = food == editvol;
      print("IseditedVol");
      print(isEditVol);
      return isEditVol ? food.copy(volume: newvolume) : food;
    }).toList());
  }

  List<DataColumn> getColumns(List<String> columns){
    return columns.map((String column) {
      final isVol = column == columns[1];
      return DataColumn(
          label: Text(column),
          // numeric: isVol,
      );
    }).toList();
  }

  List<DataRow> getRows(List<FoodDetails> allFoods) => allFoods.map((FoodDetails food) {
    final cells = [food.foodClass, food.volume];

    return DataRow(
      cells: Utils.modelBuilder(cells, (index, cell) {
        final showEditIcon = index == 0;

        return DataCell(
          Text('$cell'),
          showEditIcon: showEditIcon,
          onTap: () {
            switch (index) {
              case 0:
                editFoodClass(food);
                break;
              case 1:
                editVolume(food);
                break;
            }
          },
        );
      }),
    );
  }).toList();

  Widget buildDataTable() => DataTable(
      decoration: BoxDecoration(
        // border: Border.all(
        //   width: 1,
        //   color: Colors.black
        // )
      ),
      columns: getColumns(columns),
      rows: getRows(allFoods)
  );


  var _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Food Image',
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

              // Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // children: [
              //   Expanded(
              //     child: Image.asset('images/donuts.jpg'),
              //   ),
              //   Expanded(
              //     child: Image.asset('images/Chicken-Pad-Thai.jpg'),
              //   ),
              // ],
              // ),
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
              // SizedBox(height: 30),
              // MaterialButton(
              //     color: Colors.blue,
              //     child: const Text('Confirm Image',style: TextStyle(
              //         color: Colors.white70, fontWeight: FontWeight.bold
              //     ),),
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context)=> DisplayCalories(widget.foodImage)));
              //     }
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/4,
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

                        ScrollableWidget(child: buildDataTable()),
                        // MaterialButton(
                        //     color: Colors.blue,
                        //     child: const Text('Update information',style: TextStyle(
                        //         color: Colors.white70, fontWeight: FontWeight.bold
                        //     ),),
                        //     onPressed: () {
                        //       Navigator.push(context,
                        //           MaterialPageRoute(builder: (context)=> UpdateInfo()));
                        //     }
                        // )
                      ],
                    ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    child: const Text(
                      'Confirm Class',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.grey[300],
                      // minimumSize: Size(190, 45),
                    ),
                    onPressed: () {
                      print("SENDING LABEL");
                      print(finalFoodName);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context)=>
                                 new ShowResult(foodImage: image, foodName: finalFoodName!,)));
                    }
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

