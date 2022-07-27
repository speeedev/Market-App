import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_cebimde/screens/LoginAndRegister/LoginAndRegisterMain.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:market_cebimde/screens/app/Home.dart';
import 'firebase_options.dart';

final user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
bool isLoggedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (user != null) {
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat Regular'),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeApp();
          } else {
            return LoginAndRegisterMain();
          }
        },
      ),
    );
  }
}