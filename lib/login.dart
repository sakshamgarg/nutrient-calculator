import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrient_calculator/google_sign_in.dart';
import 'package:nutrient_calculator/home.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.yellow[400],
            body: Center(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: MediaQuery.of(context).size.height/2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/loginImage.png'),
                            fit: BoxFit.fitWidth
                        )
                    ),
                    child: Image.asset('images/loginImage.png'),
                  ),
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
                      color : Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Good Nutrition',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(62, 66, 58, 1),
                                fontSize: 28,
                                height: 1,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 188.0),
                          child: Center(
                            child: ElevatedButton.icon(
                              label: Text(
                                'Sign In with Gmail',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              icon: FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                primary: Colors.yellow[400],
                                minimumSize: Size(190, 45),
                              ),
                              onPressed: () async {
                                await GoogleSignInProvider().googleLogin();
                                // final provider =
                                // Provider.of<GoogleSignInProvider>(context, listen: false);
                                // provider.googleLogin();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder:
                                      (context)=>MyHomePage(title: 'Nutrient Calculator'))
                                );
                              },


                            ),
                          ),
                        ),
                      ],
                    ),

                  )
                ],
              ),
            ),
          );

  }
}
