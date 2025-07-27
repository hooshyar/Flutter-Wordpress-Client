import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/post.dart';
import '../screens/post_detail_screen.dart';
import '../theme/app_theme.dart';

/// Modern post card widget with Material 3 design
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => _navigateToPost(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            if (post.hasFeaturedImage) _buildFeaturedImage(context),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  if (post.categories.isNotEmpty) ...[
                    _buildCategories(theme),
                    const SizedBox(height: AppTheme.spacingS),
                  ],
                  
                  // Title
                  _buildTitle(theme),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Excerpt
                  _buildExcerpt(theme),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Footer
                  _buildFooter(context, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build featured image with loading and error states
  Widget _buildFeaturedImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Hero(
        tag: 'post-image-${post.id}',
        child: CachedNetworkImage(
          imageUrl: post.featuredImageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build categories chips
  Widget _buildCategories(ThemeData theme) {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: AppTheme.spacingXS,
      children: post.categories.take(3).map((category) {
        return Chip(
          label: Text(
            category,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
  
  /// Build post title
  Widget _buildTitle(ThemeData theme) {
    return Text(
      post.cleanTitle,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// Build post excerpt with HTML rendering
  Widget _buildExcerpt(ThemeData theme) {
    if (post.excerpt.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Html(
      data: post.excerpt,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14),
          lineHeight: LineHeight(1.5),
          maxLines: 3,
          textOverflow: TextOverflow.ellipsis,
          color: theme.colorScheme.onSurfaceVariant,
          fontFamily: 'NotoSansArabic',
        ),
        'p': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
      },
    );
  }
  
  /// Build footer with date and read more
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        // Date
        if (post.date != null) ...[
          Icon(
            Icons.schedule,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            post.timeAgo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        
        const Spacer(),
        
        // Read more button
        FilledButton.tonal(
          onPressed: () => _navigateToPost(context),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Read More',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppTheme.spacingXS),
              const Icon(
                Icons.arrow_forward,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Navigate to post detail screen
  void _navigateToPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(post: post),
      ),
    );
  }
}