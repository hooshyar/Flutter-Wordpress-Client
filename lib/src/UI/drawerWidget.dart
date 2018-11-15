import 'package:flutter/material.dart';

Widget mainDrawer(){
  return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text("data"),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent ,
                  ),
                ),
               
                drawerBtn("بابه‌تی هه‌وه‌ل"),
                drawerBtnPadding(),
                drawerBtn("بابه‌تی دوهه‌م"),
                drawerBtnPadding(),
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
                

              ],
            )
          );
}

Widget drawerBtn(String text) {
//String text ;
 
        
               return RaisedButton(
                  elevation: 2.0,
                  //textTheme: ButtonTextTheme.primary,
                  splashColor: Colors.cyan ,
                  textColor: Colors.black,
                  colorBrightness: Brightness.dark,
                  
                  child: Text(text),
                  padding: EdgeInsets.all(20.0),
                  animationDuration: Duration(microseconds: 200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0))),
                  color: Colors.amber,
                  onPressed: (){},

                );

}

Widget drawerBtnPadding() {

        return Padding(padding: EdgeInsets.all(5.0),);


}