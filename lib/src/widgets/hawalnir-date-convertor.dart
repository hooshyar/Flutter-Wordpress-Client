import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


dynamic DateConvertor(String value) {
   
   //value= "hello";
  String convertedValue;
   

     
    convertedValue = 
    DateFormat('y/M/d   H:m')
     .format(DateTime.parse(value));
   
   return  convertedValue;
     
    
}
   
    //if (!value.contains('@')) {
     // return 'Please enter a valid email';
     
     
  


