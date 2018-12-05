import 'package:flutter/material.dart';
import 'models/post.dart';
import 'models/users.dart';
import 'client.dart';
import 'package:fromscratch/wordpress_client.dart';
import 'package:http/http.dart' as http ;

WordpressClient client =   WordpressClient(_baseUrl, http.Client());
List<User> userNames ;
final String _baseUrl = 'http://ehawal.com/index.php/wp-json';

  Future<List<User>> getUsers() async {
    userNames = await client.listUser();
    return userNames;
  }



class ListViewPosts extends StatelessWidget {
  final List<Post> posts;
  final List<User> users ; 
  ListViewPosts({Key key, this.posts , this.users}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
   
    return Container(
      child: ListView.builder( 
          itemCount: posts.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            
            int usersCount = userNames.length ; 
            String authorName ;
            int userId = posts[position].author ; 
            
            for(int i = 0 ; i<usersCount ; i++ ){
              if(userId == userNames[i].id){
                authorName = userNames[i].name ; //debugPrint("user Name is " + authorName);
              } 
            }
            
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${posts[position].title}',
                    
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  
                  subtitle: Text( " author is " + authorName , 
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 35.0,
                        child: Text(
                          authorName ,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, posts[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, Post post) {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text(post.id.toString() + ' - ' + post.title.toString())));
  }
}

findUser(int userId,int usersCount){
  User user ;
  int userId;
  for(int i=0 ; i< usersCount ; i++) {
      if(userNames[i].id == userId) { 
        debugPrint(userNames[i].toString()) ;
        user = userNames[i] ;
        return user ; 
        
      } 
  }

}
/*
class ListViewUsers extends StatelessWidget {
  final List<User> userNames;

  ListViewUsers({Key key, this.userNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: userNames.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${userNames[position].name}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  
                  subtitle: Text(
                    '${userNames[position].name}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 35.0,
                        child: Text(
                          
                         '${userNames[position].name}',
                          //'User ${userNames[position].author}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, userNames[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, User userNames) {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text(userNames.name.toString() + ' - ' + userNames.name.toString())));
  } 
}
*/