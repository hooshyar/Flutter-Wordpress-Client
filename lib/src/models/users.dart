class User {
  /// Site title.
  int id;

  String name;
  
  //String avatar_urls;

  /// Blog pages show at most.
  //int postsPerPage;

  User.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    name = map['name'];
    id = map['id'] ;
    //avatar_urls = map['avatar_urls'];
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'id':id
   // 'avatar_urls': avatar_urls
  };

  toString() =>
      "User => " + toMap().toString();
}