import 'package:flutter/material.dart';
import 'package:hawalnir1/src/app.dart';
import 'package:hawalnir1/src/models/category.dart';

import '../../wordpress_client.dart';

class DrawerMain extends StatefulWidget {
  DrawerMain({Key key}) : super(key: key);

  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 10.0,
        child: Container(
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black45,
                                child: Text('Categories '),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
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
                                      margin: EdgeInsets.only(top: 4),
                                      color: Colors.white12,
                                      height: 60,
                                      child: ListTile(
                                        title: Text(_categories[index].name),
                                        subtitle: Wrap(children: [
                                          Text(
                                            _categories[index].description,
                                            softWrap: false,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ]),
                                        leading: Text(
                                          _categories[index].id.toString(),
                                        ),
                                        trailing: Container(
                                            width: 80,
                                            child:
                                                Text(_categories[index].slug)),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black45,
                              child: Text('Images '),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.transparent,
                          child: FutureBuilder<List<Media>>(
                            future: client.listMedia(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return LinearProgressIndicator();
                              } else {
                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    List<Media> _medias = snapshot.data;
                                    return Container(
                                      margin: EdgeInsets.only(top: 4),
                                      height: 60,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            _medias[index].sourceURL,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: LinearProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
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
