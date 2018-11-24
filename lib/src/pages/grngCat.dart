import 'package:flutter/material.dart';
import '../widgets/catWidgets.dart';
import '../config.dart';
import '../widgets/listViews.dart';

final String apiUrl = mainApiUrl;
List<String> posts;
String categoryId = grngId;
String hawalPerPage = perPage;
String categoryName = grngName;
List<dynamic> posts2;

class GrngCat extends StatefulWidget {
  _GrngCatState createState() => _GrngCatState();
}

class _GrngCatState extends State<GrngCat> {
  @override
  void initState() {
    super.initState();
    //this.getPosts2();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        appBar: AppBar(
            title: Text(categoryName), //TODO edit this
            backgroundColor: Colors.blueAccent),
        body: FutureBuilder<List<dynamic>>(
          future: getPosts2(apiUrl, categoryId, hawalPerPage),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ListViewPosts(postsFrom: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
