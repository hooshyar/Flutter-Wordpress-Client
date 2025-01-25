import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/post.dart';
import '../theme/app_theme.dart';
import '../screens/post_details_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  void _navigateToPostDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsScreen(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToPostDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.featuredMediaUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Hero(
                  tag: 'post-image-${post.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                    ),
                    child: Image.network(
                      post.featuredMediaUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.categories?.isNotEmpty ?? false)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: post.categories!
                          .map((category) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer
                                      .withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  category,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    post.title.rendered,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Html(
                    data: post.excerpt.rendered,
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16),
                        lineHeight: LineHeight(1.5),
                        maxLines: 3,
                        textOverflow: TextOverflow.ellipsis,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    },
                  ),
                  const SizedBox(height: 16),
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _navigateToPostDetails(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read More',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
