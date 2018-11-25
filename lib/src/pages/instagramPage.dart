import 'package:flutter/material.dart';



class InstaPage extends StatefulWidget {
  _InstaPageState createState() => _InstaPageState();
}

class _InstaPageState extends State<InstaPage> {


  Widget build(BuildContext context) {
   return  Scaffold(
      appBar: AppBar(
          title: Text("hello")
      ),
      body:
     Container(
    child: Stack(
        children: <Widget>[
       Text("text"),
       Container(
         margin: EdgeInsets.all(50.0),
         //width: 300.0 ,
          //height: 300.0 ,
          //padding: EdgeInsets.all(20.0),
          decoration:

           BoxDecoration(
               shape: BoxShape.rectangle,
               borderRadius: BorderRadius.all(Radius.circular(20.0)) ,
               color: Colors.redAccent ),
         alignment: Alignment.center,
         padding: EdgeInsets.all(20.0)
        ),
        //  BoxDecoration(shape: BoxShape.rectangle),



      ],
    ),

    )
    );
  }
}
