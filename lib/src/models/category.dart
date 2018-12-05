class Category {
  /// Unique identifier for the term.
  int id;

  /// Number of published posts for the term.
  int count;

  /// HTML description of the term.
  String description;

  /// URL of the term.
  String link;

  /// HTML title for the term
  String name;

  /// An alphanumeric identifier for the term unique to its type.
  String slug;

  /// Type attribution for the term.
  String taxonomy;

  /// The parent term ID.
  int parent;

  /// Meta fields
  dynamic meta; // List?

  Category();

  Category.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    count = map['count'];
    description = map['description'];
    link = map['link'];
    name = map['name'];
    slug = map['slug'];
    taxonomy = map['taxonomy'];
    parent = map['parent'];
    meta = map['meta'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'count': count,
    'description': description,
    'link': link,
    'name': name,
    'slug': slug,
    'taxonomy': taxonomy,
    'parent': parent,
    'meta': meta
  };

  toString() =>
      "Category => " + toMap().toString();
}
