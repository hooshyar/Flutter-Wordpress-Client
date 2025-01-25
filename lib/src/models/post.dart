class RenderedText {
  final String rendered;
  final String? raw;

  RenderedText({required this.rendered, this.raw});

  factory RenderedText.fromMap(Map<String, dynamic> map) {
    return RenderedText(
      rendered: map['rendered'] as String? ?? '',
      raw: map['raw'] as String?,
    );
  }
}

class Post {
  /// The date the object was published, in the site's timezone.
  final DateTime? date;

  /// The date the object was published, as GMT.
  //DateTime dateGMT;

  /// The globally unique identifier for the object.
  //Map guid;

  /// Unique identifier for the object.
  final int id;

  /// URL to the object.
  final String? link;

  /// The date the object was last modified, in the site's timezone.
  // DateTime modified;

  /// The date the object was last modified, as GMT.
  //DateTime modifiedGMT;

  /// An alphanumeric identifier for the object unique to its type.
  final String? slug;

  /// A named status for the object.
  ///
  /// One of: publish, future, draft, pending, private
  final String? status;

  /// Type of Post for the object.
  //String type;

  /// A password to protect access to the content and excerpt.
  //String password;

  /// The title for the object.
  final RenderedText title;

  /// The content for the object.
  final RenderedText content;

  /// The ID for the author of the object
  //int author;

  /// The ID for the author of the object
  final String? author;

  /// The excerpt for the object.
  final RenderedText excerpt;

  /// The ID of the featured media for the object.
  final int? featuredMediaId;

  /// The URL of the featured media for the object.
  final String? featuredMediaUrl;

  /// Whether or not comments are open on the object
  ///
  /// One of: open, closed
  //String commentStatus;

  /// Whether or not the object can be pinged.
  ///
  /// One of: open, close
  //String pingStatus;

  /// The format for the object.
  //String format;

  /// Meta fields.
  //dynamic meta;

  /// Whether or not the object should be treated as sticky.
  //bool sticky;

  /// The theme file to use to display the object.
  //  /String template;

  /// The terms assigned to the object in the category taxonomy.
  final List<String>? categories;

  /// The terms assigned to the object in the post_tag taxonomy.
  final List<String>? tags;

  // Injected objects
  //  Media featuredMedia;
  //User user;
  final int? authorId;

  Post({
    required this.id,
    this.date,
    required this.title,
    required this.content,
    required this.excerpt,
    this.featuredMediaUrl,
    this.categories,
    this.tags,
    this.author,
    this.authorId,
    this.link,
    this.slug,
    this.status,
    this.featuredMediaId,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : null,
      title: RenderedText.fromMap(map['title'] as Map<String, dynamic>),
      content: RenderedText.fromMap(map['content'] as Map<String, dynamic>),
      excerpt: RenderedText.fromMap(map['excerpt'] as Map<String, dynamic>),
      featuredMediaUrl:
          map['_embedded']?['wp:featuredmedia']?[0]?['source_url'] as String?,
      categories: (map['_embedded']?['wp:term']?[0] as List<dynamic>?)
          ?.map((e) => e['name'] as String)
          .toList(),
      tags: (map['_embedded']?['wp:term']?[1] as List<dynamic>?)
          ?.map((e) => e['name'] as String)
          .toList(),
      author: map['_embedded']?['author']?[0]?['name'] as String?,
      authorId: map['author'] as int?,
      link: map['link'] as String?,
      slug: map['slug'] as String?,
      status: map['status'] as String?,
      featuredMediaId: map['featured_media'] as int?,
    );
  }

  factory Post.fromMapObject(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : null,
      title: RenderedText(rendered: map['title'] as String),
      content: RenderedText(rendered: map['content'] as String),
      excerpt: RenderedText(rendered: map['excerpt'] as String),
      featuredMediaUrl: map['featured_media'] as String?,
      categories: null,
      tags: null,
      author: map['author'] as String?,
      authorId: null,
      link: map['link'] as String?,
      slug: map['slug'] as String?,
      status: map['status'] as String?,
      featuredMediaId: null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date?.toIso8601String(),
        'title': title.rendered,
        'content': content.rendered,
        'excerpt': excerpt.rendered,
        'author': author,
        'author_id': authorId,
        'featured_media': featuredMediaUrl,
        'link': link,
        'slug': slug,
        'status': status,
      };

  @override
  String toString() => 'Post{id: $id, title: ${title.rendered}}';
}
