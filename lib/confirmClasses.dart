import 'dart:ffi';
import 'dart:io';
import 'package:nutrient_calculator/updateInformation.dart';
import 'package:flutter/material.dart';
import 'package:nutrient_calculator/widget/scrollable_widget.dart';
import 'package:nutrient_calculator/widget/text_dialog_widget.dart';
import 'package:nutrient_calculator/model/food.dart';
import 'package:nutrient_calculator/data/foodexample.dart';
import 'package:nutrient_calculator/utils.dart';

import 'displayCalories.dart';

class ConfirmClasses extends StatefulWidget {
  // const ConfirmClasses({Key? key}) : super(key: key);

  File? foodImage;

  ConfirmClasses(File? image, {super.key}){
    this.foodImage = image;
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

  late List<Food> allFoods;
  final columns = ['Food Class', 'Food Volume'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.allFoods = List.of(exampleFood);
  }

  Future editFoodClass(Food editfood) async{
    final newfoodname = await showTextDialog(
        context,
        title: 'Change food class',
        value: editfood.foodClass
    );

    setState(() => allFoods = allFoods.map((food) {
      final isEditFood = food == editfood;
      return isEditFood ? food.copy(foodClass: newfoodname) : food;
    }).toList());
  }

  Future editVolume(Food editvol) async{
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
          numeric: isVol,
      );
    }).toList();
  }

  List<DataRow> getRows(List<Food> allFoods) => allFoods.map((Food food) {
    final cells = [food.foodClass, food.volume];

    return DataRow(
      cells: Utils.modelBuilder(cells, (index, cell) {
        final showEditIcon = index == 0 || index == 1;

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
        border: Border.all(
          width: 1,
          color: Colors.black
        )
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
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
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

            ],
          ),
        ),
      ),
    );
  }
}

