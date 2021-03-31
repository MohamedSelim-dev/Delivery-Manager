import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode =ThemeMode.light;

// === toggle theme light / dark ===
  void toggleTheme(){
    setState(() {
      if(themeMode == ThemeMode.light){
        themeMode = ThemeMode.dark;
      }else{
        themeMode = ThemeMode.light;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Manager',
      theme:ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey[600],
      ),
      themeMode: themeMode,
      home: HomeScreen(toggleTheme),
    );
  }
}
