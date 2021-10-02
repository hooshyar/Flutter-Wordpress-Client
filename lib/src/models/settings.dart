class Settings {
  /// Site title.
  String? title;

  /// Site tagline.
  String? description;

  /// A city in the same timezone as you.
  String? timezone;

  /// A date format for all date strings.
  String? dateFormat;

  /// A time format for all time strings.
  String? timeFormat;

  /// A day number of the week that the week should start on.
  int? startOfWeek;

  /// WordPress locale code.
  String? language;

  /// Convert emoticons like :-) and :-P to graphics on display.
  bool? useSmilies;

  /// Default post category.
  int? defaultCategory;

  /// Default post format.
  String? defaultPostFormat;

  /// Blog pages show at most.
  int? postsPerPage;

  /// Allow link notifications from other blogs (pingbacks and trackbacks) on new articles.
  String? defaultPingStatus;

  /// Allow people to post comments on new articles.
  String? defaultCommentStatus;

  Settings.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    title = map['title'];
    description = map['description'];
    timezone = map['timezone'];
    dateFormat = map['date_format'];
    timeFormat = map['time_format'];
    startOfWeek = map['start_of_week'];
    language = map['language'];
    useSmilies = map['use_smilies'];
    defaultCategory = map['default_category'];
    defaultPostFormat = map['default_post_format'];
    postsPerPage = map['posts_per_page'];
    defaultPingStatus = map['default_ping_status'];
    defaultCommentStatus = map['default_comment_status'];
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'timezone': timezone,
    'date_format': dateFormat,
    'time_format': timeFormat,
    'start_of_week': startOfWeek,
    'language': language,
    'use_smilies': useSmilies,
    'default_category': defaultCategory,
    'default_post_format': defaultPostFormat,
    'posts_per_page': postsPerPage,
    'default_ping_status': defaultPingStatus,
    'default_comment_status': defaultCommentStatus
  };

  toString() =>
      "Settings => " + toMap().toString();
}