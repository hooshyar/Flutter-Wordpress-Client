import 'package:flutter/material.dart';
import 'package:hawalnir1/src/app.dart';
import 'package:hawalnir1/src/models/category.dart';

Widget drawerMain(context) {
  debugPrint("Drawer");
  return Drawer(
    elevation: 10.0,
    child: SafeArea(
      child: Container(
        child: FutureBuilder<List<Category>>(
          future: client.listCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  List<Category> _categories = snapshot.data;
                  return Container(
                    height: 100,
                    child: ListTile(
                      
                        title: Text(_categories[index].name),
                        subtitle: Text(_categories[index].description),
                        leading: Text(
                          _categories[index].id.toString(),
                      
                        ),
                        trailing: Container( width: 50,child: Text(_categories[index].link)),
                        ),
                  );
                },
              );
            }
          },
        ),
      ),
    ),

    // ExpansionTile(
    //   initiallyExpanded: true,
    //   title: Text("Categories"),
    //   children: <Widget>[
    //     drawerBtnPadding(),
    //     drawerBtn(" CheckOFFLINE", () {
    //       Navigator.of(context).pop();
    //       Navigator.pushNamed(
    //           context, '/MainPage');
    //     }),
    //     drawerBtnPadding(),
    //     drawerBtn(" insta", () {
    //       Navigator.of(context).pop();
    //       Navigator.pushNamed(
    //           context, '/InstaPage');
    //     }),
    //     drawerBtnPadding(),

    //   ],

    // ),
  );
}

Widget kurdistanCatBtn() {
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

          child: Text("په‌ری كوردستان"),

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

Widget drawerBtn(String text, Function function) {
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
          onPressed: function,
        ),
      ]);
}

//btn social
Widget socialBtn(String text, IconData iconData, Color color) {
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
                iconData,
                color: Colors.cyan,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Text(
                text,
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
