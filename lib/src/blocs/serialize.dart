import 'package:json_annotation/json_annotation.dart';

class Post {
  int _id;
  String _title;
  String _content;
  String _author;
  String _date;
  String _imgUrl;

  //final List<post> posts ;

  Post(this._id, this._title, this._content, this._author, this._date,
      [this._imgUrl]);


}