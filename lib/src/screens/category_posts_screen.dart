import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/category.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_placeholders.dart';
import '../widgets/error_indicator.dart';

class CategoryPostsScreen extends StatefulWidget {
  final Category category;

  const CategoryPostsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryPostsScreen> createState() => _CategoryPostsScreenState();
}

class _CategoryPostsScreenState extends State<CategoryPostsScreen> {
  late final PostsProvider _postsProvider;

  @override
  void initState() {
    super.initState();
    _postsProvider = context.read<PostsProvider>();
    // Filter posts by category when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postsProvider.filterByCategory(widget.category.id);
    });
  }

  @override
  void dispose() {
    // Clear category filter when leaving the screen
    if (mounted) {
      _postsProvider.filterByCategory(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postsProvider = context.watch<PostsProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.category.name ?? 'Category',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (widget.category.count != null)
              Text(
                '${widget.category.count} posts',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => postsProvider.refreshPosts(),
        child: CustomScrollView(
          slivers: [
            if (widget.category.description?.isNotEmpty ?? false)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.category.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            if (postsProvider.isLoading &&
                postsProvider.pagingController.itemList?.isEmpty == true)
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: PostCardLoadingPlaceholder(),
                    ),
                    childCount: 3, // Show 3 loading placeholders
                  ),
                ),
              )
            else if (postsProvider.error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load posts',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        postsProvider.error!,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => postsProvider.refreshPosts(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              PagedSliverList<int, Post>(
                pagingController: postsProvider.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                  itemBuilder: (context, post, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: PostCard(post: post),
                  ),
                  firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
                    message: postsProvider.error ?? 'Failed to load posts',
                    onRetry: () => postsProvider.refreshPosts(),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: Text(
                      'No posts found in this category',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
                  newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: PostCardLoadingPlaceholder(),
                  ),
                  newPageErrorIndicatorBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => postsProvider.pagingController
                          .retryLastFailedRequest(),
                      child: const Text('Retry'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
