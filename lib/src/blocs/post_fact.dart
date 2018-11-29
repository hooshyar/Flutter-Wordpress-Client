import 'package:json_annotation/json_annotation.dart';



part 'post_fact.g.dart';


@JsonSerializable()
class PostFact {
  int _id;
  String _title;
  String _content;
  String _author;
  String _date;
  String _imgUrl;

  //final List<post> posts ;

  PostFact(this._id, this._title, this._content, this._author, this._date,
      [this._imgUrl]);

  factory PostFact.fromJson(Map<String, dynamic> json) => _$PostFactFromJson(json);
}