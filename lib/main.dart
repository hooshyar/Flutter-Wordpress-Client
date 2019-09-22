import 'package:flutter/material.dart';
import 'package:hawalnir1/src/view_models/app_key.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';


void main() {
  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider(builder: (_) => Keys()),
    ],
      child: MaterialApp(
      theme: ThemeData(
        // adding a theme

        brightness: Brightness.dark, //changing the theme to dark
        primaryColor: Colors.lightBlue[900], // color change for links
        fontFamily: 'NotoSansArabic',
        tabBarTheme: TabBarTheme(),
        iconTheme: IconThemeData(),
      ),

      home: HawalnirHome(),
      initialRoute: '/',
      // it will go and get app.dart then it will go to  HawalnirHome() from hawalnir-home.dart
      routes: <String, WidgetBuilder>{
//      '/': (BuildContext context) => HawalnirHome2(),
        //  '/GrngCat': (BuildContext context) => new GrngCat(),
        // '/KrdCat' : (BuildContext context) => new KrdCat(),
        // '/InstaPage' : (BuildContext context) => new InstaPage(), //7
//          '/MainPage' : (BuildContext context) => new MainPage() ,
      },
    ),
  ));
}
