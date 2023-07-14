import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ui_final/login.dart';
import 'package:ui_final/output.dart';
import 'package:ui_final/registration.dart';
import 'package:ui_final/app_home.dart';
import 'package:ui_final/Phone.dart';
import 'package:ui_final/Verify.dart';



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
      debugShowCheckedModeBanner: false,
      title: 'Brain Hemorrhage Detector',
      theme: ThemeData(
      primarySwatch: Colors.blue,
        primaryColor: Colors.blue,

        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blue,

        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          bodyMedium: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),

    )
      ),
      home:  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        'first':(context) => const LoginPage(),
        '/second': (context) =>  MyHomePage(),
        '/third' : (context) =>  Output(),
        '/four' : (context) => const Registration(),
        '/five' : (context) => MyPhone(),
        '/verify' : (context) => MyVerify(),
      },

    );
  }
}



