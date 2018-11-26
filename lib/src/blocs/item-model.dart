class Post {
  int _id;
  String _title;
  String _content;
  String _author;
  String _date;
  String _imgUrl;

  Post(this._id, this._title, this._content, this._author, this._date,
      [this._imgUrl]);

  Post.withId(this._id, this._title, this._content, this._author, this._date,
      [this._imgUrl]);

  int get id => _id;
  String get title => _title;
  String get content => _content;
  String get author => _author;
  String get date => _date;
  String get imgUrl => _imgUrl;

  set title(String newTitle) {
    this._title = newTitle;
  }

  set content(String newContent) {
    this._content = newContent;
  }

  set author(String newAuthor) {
    this._author = newAuthor;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set imgUrl(String newImgUrl) {
    this._imgUrl = newImgUrl ;
  }



  //convert post to Map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['content'] = _content;
    map['author'] = _author;
    map['date'] = _date;
    map['imgurl'] = _imgUrl;
    return map;
  }





  //Extract post from Map Object
 Post.fromMapObject(Map<String , dynamic>map ){
    this._id = map['id'];
    this._title = map['title'];
    this._content = map['content'];
    this._author = map['author'];
    this._date = map['date'];
    this._imgUrl = map['imgurl'];

 }


}
