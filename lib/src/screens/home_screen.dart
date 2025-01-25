import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../providers/categories_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_indicator.dart';
import '../theme/app_theme.dart';
import 'categories_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category_posts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Add error handling for SharedPreferences
    try {
      SharedPreferences.getInstance().then((prefs) {
        // Initialize preferences here
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to initialize preferences. Some features may be limited.'),
          ),
        );
      });
    } catch (e) {
      // Handle any synchronous errors
    }

    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            title: Text(
              'WP Client',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            stretch: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.category_outlined),
                tooltip: 'Categories',
                onPressed: () async {
                  final category = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                  if (category != null && context.mounted) {
                    // TODO: Filter posts by selected category
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {
                  // TODO: Implement search
                },
              ),
              IconButton(
                icon: const Icon(Icons.dark_mode),
                tooltip: 'Toggle theme',
                onPressed: () {
                  // TODO: Toggle theme
                },
              ),
            ],
          ),
          Consumer<PostsProvider>(
            builder: (context, postsProvider, _) {
              if (postsProvider.isLoading &&
                  postsProvider.pagingController.itemList?.isEmpty == true) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (postsProvider.error != null) {
                return SliverFillRemaining(
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
                );
              }

              return PagedSliverList<int, Post>(
                pagingController: postsProvider.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                  itemBuilder: (context, post, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: PostCard(post: post),
                  ),
                  firstPageErrorIndicatorBuilder: (_) => Center(
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
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => postsProvider.refreshPosts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: Text(
                      'No posts found',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoriesProvider>();
    final posts = context.watch<PostsProvider>();
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Categories',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  if (posts.selectedCategoryId != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Filter'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        posts.filterByCategory(null);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (categories.isLoading)
            const LoadingIndicator()
          else if (categories.error?.isNotEmpty ?? false)
            ErrorIndicator(
                message: categories.error ?? 'Failed to load categories')
          else
            Expanded(
              child: ListView.builder(
                itemCount: categories.categories.length,
                itemBuilder: (context, index) {
                  final category = categories.categories[index];
                  final isSelected = category.id == posts.selectedCategoryId;

                  return ListTile(
                    title: Text(
                      category.name ?? 'Unnamed Category',
                      style: isSelected
                          ? TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            )
                          : null,
                    ),
                    leading: category.count != null
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${category.count}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : null,
                    selected: isSelected,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPostsScreen(
                            category: category,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
