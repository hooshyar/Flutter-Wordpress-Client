import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'blocs/database_helper.dart';
import 'app2.dart';

bool netConnection;
var dbHelper = DatabaseHelper();

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Icon(Icons.access_alarm),),
//    body: Container(child: offlineCheck()) ,

    );


  }
}
//doWeHaveNet();
//    if (doWeHaveNet() != true) {
//      debugPrint(" FALSE ALL ");
//      return Container(
//          child: RaisedButton(
//        onPressed: () {
//         // doWeHaveNet();
//          //debugPrint(" true one ");
//
//          if (doWeHaveNet() == true) {
//            debugPrint(" true ONE ");
//            Navigator.of(context).pushNamed('/HawalnirHome2');
//          }else {
//
//            debugPrint("try again ");
//            if(doWeHaveNet() != false){
//              print(doWeHaveNet().toString());
//              Navigator.of(context).pushNamed('/HawalnirHome2');
//            }
//
//          }
//        },
//        child: Text("dsdsd"),
//      ));
//    }else {
//      debugPrint(" false 1");
//      return HawalnirHome2();
//    } }
//}
//
//doWeHaveNet() async {
//  //TODO POP something to know connection is lost
//  int count = await dbHelper.getCount();
//  try {
//    final result = await InternetAddress.lookup('google.com');
//    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//      print('connected');
//      netConnection = true;
////      return weHaveNet(HawalnirHome2State().context);
//      return true;
//    }
//
//  } on SocketException catch (_) {
//    print('not connected');
//    if (count < 1) {
//      debugPrint('we need intenet');
////      netConnection = false;
////      return false;
//    }
//  }
//
//  //TODO put a nice widget here for Connectivity problems