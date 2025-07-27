/// Simplified Post model for WordPress REST API
class Post {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String? featuredImageUrl;
  final String? link;
  final String? slug;
  final DateTime? date;
  final String? authorName;
  final List<String> categories;
  final List<String> tags;
  
  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    this.featuredImageUrl,
    this.link,
    this.slug,
    this.date,
    this.authorName,
    this.categories = const [],
    this.tags = const [],
  });
  
  /// Create Post from WordPress REST API JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: _extractRendered(json['title']),
      content: _extractRendered(json['content']),
      excerpt: _extractRendered(json['excerpt']),
      featuredImageUrl: _extractFeaturedImage(json),
      link: json['link'] as String?,
      slug: json['slug'] as String?,
      date: _parseDate(json['date']),
      authorName: _extractAuthorName(json),
      categories: _extractCategories(json),
      tags: _extractTags(json),
    );
  }
  
  /// Extract rendered text from WordPress rendered object
  static String _extractRendered(dynamic field) {
    if (field is Map<String, dynamic> && field.containsKey('rendered')) {
      return field['rendered'] as String? ?? '';
    }
    return field?.toString() ?? '';
  }
  
  /// Extract featured image URL from embedded data
  static String? _extractFeaturedImage(Map<String, dynamic> json) {
    try {
      final embedded = json['_embedded'] as Map<String, dynamic>?;
      final featuredMedia = embedded?['wp:featuredmedia'] as List?;
      if (featuredMedia != null && featuredMedia.isNotEmpty) {
        final media = featuredMedia.first as Map<String, dynamic>;
        return media['source_url'] as String?;
      }
    } catch (e) {
      // Fallback: try to get from media_details or other fields
    }
    return null;
  }
  
  /// Extract author name from embedded data
  static String? _extractAuthorName(Map<String, dynamic> json) {
    try {
      final embedded = json['_embedded'] as Map<String, dynamic>?;
      final authors = embedded?['author'] as List?;
      if (authors != null && authors.isNotEmpty) {
        final author = authors.first as Map<String, dynamic>;
        return author['name'] as String?;
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }
  
  /// Extract categories from embedded data
  static List<String> _extractCategories(Map<String, dynamic> json) {
    try {
      final embedded = json['_embedded'] as Map<String, dynamic>?;
      final terms = embedded?['wp:term'] as List?;
      if (terms != null && terms.isNotEmpty) {
        final categories = terms.first as List?;
        if (categories != null) {
          return categories
              .map((cat) => cat['name'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      // Silent fail
    }
    return [];
  }
  
  /// Extract tags from embedded data
  static List<String> _extractTags(Map<String, dynamic> json) {
    try {
      final embedded = json['_embedded'] as Map<String, dynamic>?;
      final terms = embedded?['wp:term'] as List?;
      if (terms != null && terms.length > 1) {
        final tags = terms[1] as List?;
        if (tags != null) {
          return tags
              .map((tag) => tag['name'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      // Silent fail
    }
    return [];
  }
  
  /// Parse date string to DateTime
  static DateTime? _parseDate(dynamic dateField) {
    if (dateField is String) {
      try {
        return DateTime.parse(dateField);
      } catch (e) {
        // Silent fail
      }
    }
    return null;
  }
  
  /// Get clean title without HTML
  String get cleanTitle => _cleanHtml(title);
  
  /// Get clean excerpt without HTML
  String get cleanExcerpt => _cleanHtml(excerpt);
  
  /// Get clean content without HTML (for previews)
  String get cleanContent => _cleanHtml(content);
  
  /// Simple HTML cleaning (basic implementation)
  static String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .trim();
  }
  
  /// Get relative time string
  String get timeAgo {
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date!);
    
    if (difference.inDays > 7) {
      return '${date!.day}/${date!.month}/${date!.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Check if post has featured image
  bool get hasFeaturedImage => featuredImageUrl != null && featuredImageUrl!.isNotEmpty;
  
  /// Get preview text (limited excerpt)
  String getPreview([int maxLength = 150]) {
    final text = cleanExcerpt.isNotEmpty ? cleanExcerpt : cleanContent;
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength).trim()}...';
  }
  
  @override
  String toString() => 'Post(id: $id, title: $cleanTitle)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}