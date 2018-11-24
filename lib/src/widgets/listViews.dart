import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import '../widgets/catWidgets.dart';


class ListViewPosts extends StatelessWidget {
  final List<dynamic> postsFrom;

  ListViewPosts({Key key, this.postsFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text(postsFrom.toString(),


   return Directionality(
       textDirection: TextDirection.rtl, // RTL
       child:  Scaffold(


    body:ListView.builder(
        itemCount: postsFrom.length, //== null ? 0 : postsFrom.length,
        itemBuilder: (context, int index) {
         return Card(
           child: Column(
             children: <Widget>[
               Container(
                 child: hawalImage(postsFrom, index),
               ),
               new Padding(
                 padding: EdgeInsets.all(5.0),
                 child: new ListTile(
                   onTap: () {
                     Navigator.push(
                       context,
                       new MaterialPageRoute(
                         builder: (context) =>
                             HawalnirPost(post: postsFrom[index]),
                       ),
                     );
                   },
                   title: hawalTitle(postsFrom, index),
                   subtitle: new Row(
                     children: <Widget>[
                       Expanded(
                         child: hawalAuthor(postsFrom, index),
                       ),
                       Expanded(
                         child: hawalDate(postsFrom, index),
                       ),
                     ],
                   ),
                 ),
               ),
               new ButtonTheme.bar(
                 child: hawalBtnBar(),
               ),
             ],
           ),
         );
        },


      ),
       ));
   }

}
