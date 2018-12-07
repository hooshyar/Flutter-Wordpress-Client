import 'media.dart';


class Post {
  /// The date the object was published, in the site's timezone.
  DateTime date;

  /// The date the object was published, as GMT.
  DateTime dateGMT;

  /// The globally unique identifier for the object.
  Map guid;

  /// Unique identifier for the object.
  int id;

  /// URL to the object.
  String link;

  /// The date the object was last modified, in the site's timezone.
  DateTime modified;

  /// The date the object was last modified, as GMT.
  DateTime modifiedGMT;

  /// An alphanumeric identifier for the object unique to its type.
  String slug;

  /// A named status for the object.
  ///
  /// One of: publish, future, draft, pending, private
  String status;

  /// Type of Post for the object.
  String type;

  /// A password to protect access to the content and excerpt.
  String password;

  /// The title for the object.
  String title;

  /// The content for the object.
  String content;

  /// The ID for the author of the object
  int author;

 /// The ID for the author of the object
  String authorName;

  /// The excerpt for the object.
  Map excerpt;

  /// The ID of the featured media for the object.
  int featuredMediaID;

  /// The URL of the featured media for the object.
 dynamic featuredMediaUrl;

  /// Whether or not comments are open on the object
  ///
  /// One of: open, closed
  String commentStatus;

  /// Whether or not the object can be pinged.
  ///
  /// One of: open, close
  String pingStatus;

  /// The format for the object.
  String format;

  /// Meta fields.
  dynamic meta;

  /// Whether or not the object should be treated as sticky.
  bool sticky;

  /// The theme file to use to display the object.
  String template;

  /// The terms assigned to the object in the category taxonomy.
  List<int> categories;

  /// The terms assigned to the object in the post_tag taxonomy.
  List tags;

  // Injected objects
  Media featuredMedia;
  //User user;
  Post();

  Post.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    date = map["date"] != null
        ? DateTime.parse(map["date"])
        : null;
    dateGMT = map["date_gmt"] != null
        ? DateTime.parse(map["date_gmt"])
        : null;
    guid = map['guid'];
    id = map['id'];
    link = map['link'];
    modified = map["modified"] != null
        ? DateTime.parse(map["modified"])
        : null;
    modifiedGMT = map["modified_gmt"] != null
        ? DateTime.parse(map["modified_gmt"])
        : null;
    slug = map['slug'];
    status = map['status'];
    type = map['type'];
    password = map['password'];
    title = map['title']['rendered'];
    content = map['content']['rendered'];
    author = map['author'];
    authorName = map["_embedded"]["author"][0]["name"];
    excerpt = map['excerpt'];
    featuredMediaID = map['featured_media'];
    //featuredMediaUrl = map ['_links']["self"][0]['href'] ;
    featuredMediaUrl = map ["_embedded"]["wp:featuredmedia"][0]["source_url"];
    commentStatus = map['comment_status'];
    pingStatus = map['ping_status'];
    format = map['format'];
    meta = map['meta'];
    sticky = map['sticky'];
    template = map['template'];
    tags = map['tags'];

    // Avoiding (odd) cast warnings
    categories = new List();
    for (dynamic item in map['categories']) {
      if (item is int) {
        categories.add(item);
      }
    }
  }

  Map<String, dynamic> toMap() => {
        'date': date?.toIso8601String(),
        'date_gmt': dateGMT?.toIso8601String(),
        'guid': guid,
        'id': id,
        'link': link,
        'modified': modified?.toIso8601String(),
        'modified_gmt': modifiedGMT?.toIso8601String(),
        'slug': slug,
        'status': status,
        'type': type,
        'password': password,
        'title': title,
        'content': content,
        'author': authorName,
        //'authorName':authorName,
        'excerpt': excerpt,
        'featured_media': featuredMediaUrl,

        'comment_status': commentStatus,
        'ping_status': pingStatus,
        'format': format,
        'meta': meta,
        'sticky': sticky,
        'template': template,
        'categories': categories,
        'tags': tags
      };

  toString() => "Post => " + toMap().toString();

  Post.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
    this.authorName = map['author'];
    this.date = map["date"] != null
        ? DateTime.parse(map["date"])
        : null;
    this.featuredMediaUrl = map['featured_media'];
  }
}

