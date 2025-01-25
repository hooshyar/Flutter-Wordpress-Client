import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/post.dart';
import '../theme/app_theme.dart';

class PostDetailsScreen extends StatelessWidget {
  final Post post;

  const PostDetailsScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver app bar with hero image
          SliverAppBar(
            expandedHeight: post.featuredMediaUrl != null ? 300.0 : 0.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: post.featuredMediaUrl != null
                  ? Hero(
                      tag: 'post-image-${post.id}',
                      child: Image.network(
                        post.featuredMediaUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          // Post content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  if (post.categories?.isNotEmpty ?? false)
                    Wrap(
                      spacing: 8,
                      children: post.categories!
                          .map((category) => Chip(
                                label: Text(
                                  category,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    post.title.rendered,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Date and author
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeago.format(post.date ?? DateTime.now()),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (post.author != null) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post.author!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Content
                  Html(
                    data: post.content.rendered,
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16),
                        lineHeight: LineHeight(1.6),
                        color: theme.colorScheme.onSurface,
                      ),
                      'figure': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      'img': Style(
                        width: Width(MediaQuery.of(context).size.width - 32),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
