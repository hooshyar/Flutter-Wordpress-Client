import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categories_provider.dart';
import '../widgets/loading_placeholders.dart';
import '../widgets/error_indicator.dart';
import '../screens/category_posts_screen.dart';
import '../widgets/shimmer_loading.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.background,
        title: Text(
          'Categories',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, categories, _) {
          if (categories.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const ShimmerLoading(
                                  isLoading: true,
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CategoryLoadingPlaceholder(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const ShimmerLoading(
                            isLoading: true,
                            child: SizedBox(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const ShimmerLoading(
                            isLoading: true,
                            child: SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (categories.error?.isNotEmpty ?? false) {
            return Center(
              child: ErrorIndicator(
                message: categories.error ?? 'Failed to load categories',
                onRetry: () => categories.refreshCategories(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: categories.refreshCategories,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.categories.length,
              itemBuilder: (context, index) {
                final category = categories.categories[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  category.name ?? 'Unnamed Category',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              if (category.count != null)
                                Container(
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
                                    '${category.count} posts',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme
                                          .colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (category.description?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 8),
                            Text(
                              category.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'View Posts',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
