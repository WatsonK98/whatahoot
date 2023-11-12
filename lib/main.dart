import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:whatahoot/pages/home_page.dart';

///Created Samuel R. Sanchez

///Application starting point and initialization
void main() async {

  //Ensure the initialization of frameworks
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase network backends
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Start the App
  runApp(const MyApp());
}

///Widget container, preloads theme data into memory
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatahoot preview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Whatahoot!'),
    );
  }
}
