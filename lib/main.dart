import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'src/app.dart';
void main() {


  runApp(MaterialApp(
    theme: ThemeData( // adding a theme 
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        
      
      ),
      home: HawalnirHome()
       
      
    
  ));
}
