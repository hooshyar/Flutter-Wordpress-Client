/// Simplified Category model for WordPress REST API
class WPCategory {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int count;
  final int parent;
  final String? link;
  
  const WPCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description = '',
    this.count = 0,
    this.parent = 0,
    this.link,
  });
  
  /// Create WPCategory from WordPress REST API JSON
  factory WPCategory.fromJson(Map<String, dynamic> json) {
    return WPCategory(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      parent: json['parent'] as int? ?? 0,
      link: json['link'] as String?,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'count': count,
      'parent': parent,
      'link': link,
    };
  }
  
  /// Check if category has posts
  bool get hasPosts => count > 0;
  
  /// Check if category is top-level (no parent)
  bool get isTopLevel => parent == 0;
  
  /// Get display name with post count
  String get displayName => '$name ($count)';
  
  @override
  String toString() => 'WPCategory(id: $id, name: $name, count: $count)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WPCategory && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}