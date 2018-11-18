import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/pages/getCategories.dart';
import 'src/pages/kurdistan-cat.dart';
import 'src/pages/kurdistanCat.dart';

void main() {


  runApp(MaterialApp(
    theme: ThemeData( // adding a theme 
        brightness: Brightness.dark, //changing the theme to dark
        primaryColor: Colors.lightBlue[800], // color change for links 
        accentColor: Colors.cyan[600], // i dont know 
        fontFamily: 'NotoSansArabic'
        
      
      ),
      home: HawalnirHome(), // it will go and get app.dart then it will go to  HawalnirHome() from hawalnir-home.dart
      routes: <String , WidgetBuilder> {
        '/screen1': (BuildContext context) => new Screen2(), //6
        '/KrdCat' : (BuildContext context) => new KrdCat(), //7
      },
      
    
  ));
}




