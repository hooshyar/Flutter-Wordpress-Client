import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

import '../models/post.dart';
import '../theme/app_theme.dart';

/// Post detail screen with rich content display
class PostDetailScreen extends StatelessWidget {
  final Post post;
  
  const PostDetailScreen({
    super.key,
    required this.post,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with featured image
          _buildAppBar(context),
          
          // Content
          SliverToBoxAdapter(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }
  
  /// Build app bar with featured image
  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      expandedHeight: post.hasFeaturedImage ? 300 : 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingXS,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Text(
            post.cleanTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: post.hasFeaturedImage
            ? Hero(
                tag: 'post-image-${post.id}',
                child: CachedNetworkImage(
                  imageUrl: post.featuredImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 48,
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        // Share button
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _sharePost(context),
        ),
      ],
    );
  }
  
  /// Build content section
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post meta information
          _buildPostMeta(theme),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Post title (for non-featured image posts)
          if (!post.hasFeaturedImage) ...[
            _buildTitle(theme),
            const SizedBox(height: AppTheme.spacingL),
          ],
          
          // Categories
          if (post.categories.isNotEmpty) ...[
            _buildCategories(theme),
            const SizedBox(height: AppTheme.spacingL),
          ],
          
          // Content
          _buildHtmlContent(theme),
          
          const SizedBox(height: AppTheme.spacingXL),
          
          // Tags
          if (post.tags.isNotEmpty) ...[
            _buildTags(theme),
            const SizedBox(height: AppTheme.spacingL),
          ],
          
          // Actions
          _buildActions(context, theme),
          
          // Bottom spacing
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }
  
  /// Build post meta information
  Widget _buildPostMeta(ThemeData theme) {
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
        
        // Author
        if (post.authorName != null) ...[
          const SizedBox(width: AppTheme.spacingM),
          Icon(
            Icons.person,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            post.authorName!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
  
  /// Build title (for posts without featured image)
  Widget _buildTitle(ThemeData theme) {
    return Text(
      post.cleanTitle,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }
  
  /// Build categories
  Widget _buildCategories(ThemeData theme) {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: AppTheme.spacingS,
      children: post.categories.map((category) {
        return Chip(
          label: Text(
            category,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
        );
      }).toList(),
    );
  }
  
  /// Build HTML content
  Widget _buildHtmlContent(ThemeData theme) {
    return Html(
      data: post.content,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.6),
          color: theme.colorScheme.onSurface,
          fontFamily: 'NotoSansArabic',
        ),
        'p': Style(
          margin: Margins.only(bottom: 16),
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.6),
        ),
        'h1, h2, h3, h4, h5, h6': Style(
          margin: Margins.only(top: 24, bottom: 16),
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        'h1': Style(fontSize: FontSize(28)),
        'h2': Style(fontSize: FontSize(24)),
        'h3': Style(fontSize: FontSize(20)),
        'blockquote': Style(
          margin: Margins.only(left: 16, right: 16, top: 16, bottom: 16),
          padding: HtmlPaddings.only(left: 16),
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.primary,
              width: 4,
            ),
          ),
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          fontStyle: FontStyle.italic,
        ),
        'a': Style(
          color: theme.colorScheme.primary,
          textDecoration: TextDecoration.underline,
        ),
        'img': Style(
          margin: Margins.only(top: 16, bottom: 16),
        ),
        'pre': Style(
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          padding: HtmlPaddings.all(12),
          margin: Margins.only(top: 16, bottom: 16),
        ),
        'code': Style(
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
          fontSize: FontSize(14),
          fontFamily: 'monospace',
        ),
        'ul, ol': Style(
          margin: Margins.only(top: 8, bottom: 16),
          padding: HtmlPaddings.only(left: 20),
        ),
        'li': Style(
          margin: Margins.only(bottom: 8),
        ),
      },
    );
  }
  
  /// Build tags
  Widget _buildTags(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Wrap(
          spacing: AppTheme.spacingS,
          runSpacing: AppTheme.spacingS,
          children: post.tags.map((tag) {
            return ActionChip(
              label: Text(
                '#$tag',
                style: theme.textTheme.labelSmall,
              ),
              onPressed: () {
                // Could implement tag-based filtering here
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  /// Build action buttons
  Widget _buildActions(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        // Share button
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _sharePost(context),
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ),
        
        const SizedBox(width: AppTheme.spacingM),
        
        // Copy link button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _copyLink(context),
            icon: const Icon(Icons.link),
            label: const Text('Copy Link'),
          ),
        ),
      ],
    );
  }
  
  /// Share post
  void _sharePost(BuildContext context) {
    final shareText = '${post.cleanTitle}\n\n${post.link ?? ''}';
    Share.share(
      shareText,
      subject: post.cleanTitle,
    );
  }
  
  /// Copy post link
  void _copyLink(BuildContext context) {
    if (post.link != null) {
      Clipboard.setData(ClipboardData(text: post.link!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}