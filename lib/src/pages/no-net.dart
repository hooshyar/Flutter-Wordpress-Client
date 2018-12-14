import '../app2.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
       child: Column(
         children: <Widget>[

           Text('Not Internet connection please try again') ,
           RaisedButton(onPressed: (){
             doWeHaveNet() ;
           })


         ],
       )


      ),

    );
  }
}
