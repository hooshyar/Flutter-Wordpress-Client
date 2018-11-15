import 'package:flutter/material.dart';

Widget mainDrawer() {
  return Drawer(
      child: ListView(
    //physics: BouncingScrollPhysics(),

    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text("data"),
        decoration: BoxDecoration(
          color: Colors.amberAccent,
        ),
      ),
      
socialBtn("text", Icon(Icons.access_alarms), Colors.indigo[900]),
     
     drawerBtnPadding(),
      ExpansionTile(
        initiallyExpanded: true,
        title: Text("بابه‌ته‌كانی هه‌واڵ"),
        children: <Widget>[
          
          
          drawerBtn("بابه‌تی سێ"),
          drawerBtnPadding(),
          drawerBtn("hello"),
          drawerBtnPadding(),
          drawerBtn("hello"),
          drawerBtnPadding(),
          drawerBtn("hello"),
          drawerBtnPadding(),
          drawerBtn("hello"),
          drawerBtnPadding(),
          drawerBtn("hello"),
          drawerBtnPadding(),
        ],
      ),

      drawerBtn("text"),
    ],
  ));
}

Widget drawerBtn(String text) {
//String text ;

  return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
          elevation: 2.0,
          //textTheme: ButtonTextTheme.primary,
          splashColor: Colors.cyan,
          textColor: Colors.black,
          colorBrightness: Brightness.dark,

          child: Text(text),

          padding: EdgeInsets.all(20.0),
          animationDuration: Duration(microseconds: 200),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0))),
          color: Colors.amber,
          onPressed: () {},
        ),
      ]);
}

//btn social
Widget socialBtn(String text, Widget iconData, Color color) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
       // Padding(
         // padding: EdgeInsets.all(20.0),
        //),
        RaisedButton(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add_a_photo,
                color: Colors.cyan,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Text(
                'فه‌یسبوكی كوردی',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          elevation: 2.0,
          //textTheme: ButtonTextTheme.primary,
          splashColor: Colors.cyan,
          textColor: Colors.black,
          colorBrightness: Brightness.dark,
          padding: EdgeInsets.all(20.0),

          animationDuration: Duration(microseconds: 200),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0))),
          color: color,
          onPressed: () {},
        ),
      ]);
}

Widget drawerBtnPadding() {
  return Padding(
    padding: EdgeInsets.all(5.0),
  );
}
