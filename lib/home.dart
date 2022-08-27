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

import 'confirmClasses.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? image;
  final TextEditingController _typeAheadController = TextEditingController();

  Future pickImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;

      final imageTemp = File(image.path);

      setState(()=> this.image = imageTemp);
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
      setState(()=> this.image = imagePermanent);
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
                  'Search Food',
                  textAlign: TextAlign.left,
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> ConfirmClasses(image)));
                }
            )
          ],
        ),
      ),
    );
  }
}