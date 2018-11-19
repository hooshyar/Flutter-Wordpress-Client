import 'package:flutter/material.dart';
import 'src/app.dart';
//import 'src/pages/getCategories.dart';
//import 'src/pages/kurdistan-cat.dart';
import 'src/pages/kurdistanCat.dart';
import 'src/pages/grngCat.dart';


void main() {


  runApp(MaterialApp(
    
    theme: ThemeData( // adding a theme 

        brightness: Brightness.dark, //changing the theme to dark
        primaryColor: Colors.lightBlue[900], // color change for links 
        accentColor: Colors.cyan[600], // i dont know 
        fontFamily: 'NotoSansArabic' ,
        tabBarTheme: TabBarTheme(
        
        ),
        iconTheme: IconThemeData(

        ),
                
        
      
      ),
      
      
      home: HawalnirHome(), // it will go and get app.dart then it will go to  HawalnirHome() from hawalnir-home.dart
      routes: <String , WidgetBuilder> {
        '/GrngCat': (BuildContext context) => new GrngCat(), //6
        '/KrdCat' : (BuildContext context) => new KrdCat(), //7
      },
      
    
  ));
}




