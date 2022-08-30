import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_calculator/google_sign_in.dart';
import 'package:nutrient_calculator/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:nutrient_calculator/autocomplete_api.dart';

import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:nutrient_calculator/classifier.dart';
import 'package:nutrient_calculator/classifier_quant.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:typed_data';

import 'confirmClasses.dart';
import 'package:nutrient_calculator/showResult.dart';
import 'package:nutrient_calculator/facebook_Segment.dart';
import 'package:nutrient_calculator/facebook_Classify.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Classifier _classifier;
  var logger = Logger();


  File? image;

  Image? _imageWidget;
  img.Image? fox;
  Category? category;
  bool isCamera = true;
  String foodFromType = "";

  List<FacebookClassify>? facebookClassify;
  List<FacebookSegment>? facebookSegment;

  String? finalFood;
  String? finalScore;

  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _classifier = ClassifierQuant();
  }

  Future<void> _predictFacebookSegment() async{

    final imagebytes = await this.image!.readAsBytes();
    final response = await http.
    post(Uri.parse('https://api-inference.huggingface.co/models/facebook/detr-resnet-50'),
        headers: {'Content-type': 'application/json', 'Authorization': 'Bearer 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'},
        body: imagebytes);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Facebook Segment");
      final facebookSegment = facebookSegmentFromJson(response.body);
      if (facebookSegment.isNotEmpty){
        print(facebookSegment[0].label.toString());
        print(facebookSegment[0].score.toStringAsFixed(3));
      }
      setState(() {
        this.facebookSegment = facebookSegment;
      });

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _predictFacebookClassify() async{

    final imagebytes = await this.image!.readAsBytes();
    final response = await http.
    post(Uri.parse('https://api-inference.huggingface.co/models/facebook/deit-base-distilled-patch16-224'),
        headers: {'Content-type': 'application/json', 'Authorization': 'Bearer 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'},
        body: imagebytes);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
      final facebookClassify = facebookClassifyFromJson(response.body);
      print("Facebook Classify");
      print(facebookClassify[0].label.toString());
      print(facebookClassify[0].score.toStringAsFixed(3));
      setState(() {
        this.facebookClassify = facebookClassify;
      });
      // return Album.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void _predict() async{
    img.Image imageInput = img.decodeImage(this.image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);
    if (pred != null){

      print("Tensorflow lite");
      print(pred!.label);
      print("CONFIDENCE");
      print(pred!.score.toStringAsFixed(3));
    } else {
      print("NOTHING PREDICTED");
    }
    setState(() {
      this.category = pred;
    });
  }

  void _compareScoreLabel() async {
    if (this.facebookSegment == null && this.facebookClassify == null){
      this.finalFood = "Burger";
      this.finalScore = "1";
    } else if (this.facebookSegment!.isEmpty){
      print("INSIDE second IF");
      this.finalFood = this.facebookClassify![0].label.toString();
      this.finalScore = this.facebookClassify![0].score.toStringAsFixed(3);
    } else {
      var x = this.facebookClassify![0].score;
      var y = this.facebookSegment![0].score;
      if (x>=y){
        this.finalFood = this.facebookClassify![0].label.toString();
        this.finalScore = this.facebookClassify![0].score.toStringAsFixed(3);
      } else {
        this.finalFood = this.facebookSegment![0].label.toString();
        this.finalScore = this.facebookSegment![0].score.toStringAsFixed(3);
      }
    }
  }

  Future pickImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;

      final imageTemp = File(image.path);
      print("PRINTING IMAGE");
      print(image);

      setState(() {
        this.image = imageTemp;
        this._imageWidget = Image.file(this.image!);
        // _predict();
        // _predictFacebookSegment();
        // _predictFacebookClassify();
      }
      );
      await _predictFacebookClassify();
      await _predictFacebookSegment();
      _compareScoreLabel();
    } on PlatformException catch(e){
      print('Failed to laod image: $e');
    }
  }

  Future pickImageCamera() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null) return;

      // final imageTemp = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState((){
        this.image = imagePermanent;
        this._imageWidget = Image.file(this.image!);
        // _predict();
      }
      );
      await _predictFacebookSegment();
      await _predictFacebookClassify();
      _compareScoreLabel();
    } on PlatformException catch(e){
      print('Failed to laod image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context){

    final currUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi ' + currUser.displayName! +' !',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () async {
                await GoogleSignInProvider().logout();
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage())
                    );
              },
              child: Text('logout'))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Find Nutrients in food of your choice',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 22,
                      height: 1,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: TypeAheadField<FoodFromApi?>(
                hideSuggestionsOnKeyboardHide: false,
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(

                    controller: _typeAheadController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      hintText: 'Type the Name of the Food',

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
                  this.isCamera = false;
                  this.foodFromType = food.name.toString();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'OR',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 18,
                      height: 1,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            image!= null ?
            Container(
              width: 300,
              height: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                // image: DecorationImage(
                //     image: AssetImage('images/demoImage.png'),
                //     fit: BoxFit.fitWidth
                // ),
              ),
              child: Image.file(image!),
            )
                :
            Container(
              width: 300,
              height: 250,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                      image: AssetImage('images/demoImage.png'),
                      fit: BoxFit.fitWidth
                  ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Open Camera to find Nutrient',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 14,
                      height: 1,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(child: ElevatedButton(
                      child: const Text(
                        'Open Gallery',
                        style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.grey[300],
                        minimumSize: Size(190, 45),
                      ),
                      onPressed: () {
                        pickImage();
                        this.isCamera = true;
                      }
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(child: ElevatedButton(
                      child: const Text('Open Camera',style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.grey[300],
                        minimumSize: Size(190, 45),
                      ),
                      onPressed: () {
                        pickImageCamera();
                        this.isCamera = true;
                      }
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20,),
            // image!= null ? Image.file(image!) : Text('No image selected'),
            ElevatedButton(
                child: const Text(
                  'Get calories',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Colors.grey[300],
                  minimumSize: Size(190, 45),
                ),
                onPressed: () {
                  this.isCamera ?
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> ConfirmClasses(image, finalFood, finalScore))) :
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> new ShowResult(foodImage: image, foodName: this.foodFromType,)));
                }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  facebookClassify != null ? 'Category: ${finalFood}' : '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 14,
                      height: 1,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  facebookClassify != null ?
                  'Confidence: ${finalScore}' : '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 14,
                      height: 1,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}