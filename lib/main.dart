import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:nutrient_calculator/home.dart';
import 'package:nutrient_calculator/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrient Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100,
                width: 100,
                child: Image.asset('images/nyu.png')
            ),
            const Text('Nutrient Calculator',
                style: TextStyle(
                  fontSize: 36 ,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple
            ),)
            // Container(
            //     height: 100,
            //     width: 100,
            //     child: Image.asset('images/nyu.png')
            // ),
            // const Text('Nutrient Calculator',
            //   style: TextStyle(
            //       fontSize: 40,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.purple
            //   ),
            // )
          ],
        ),
        // Icons.food_bank,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.yellow,
      splashIconSize: 400,
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(height: 100,width: 100,color: Colors.amber),
      //       Container(
      //         child: Text('Diet Vision',
      //             style: TextStyle(fontSize: 24,
      //                 fontWeight: FontWeight.bold)),
      //       ),
      //     ],
      //   ),
      // ),
      // nextScreen: MyHomePage(title: 'Diet Vision',),),
      nextScreen: LoginPage(),),
    );
  }
}


