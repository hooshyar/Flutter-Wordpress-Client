import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/post.dart';
import '../providers/wordpress_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../theme/app_theme.dart';
import '../config/wordpress_config.dart';
import 'categories_screen.dart';

/// Modern home screen with WordPress posts
/// 
/// Features:
/// - Infinite scroll pagination
/// - Search functionality
/// - Category filtering
/// - Pull to refresh
/// - Error handling with retry
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchVisible = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WordPressProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              // App Bar
              _buildAppBar(context, provider),
              
              // Search Bar (when visible)
              if (_isSearchVisible) _buildSearchBar(context, provider),
              
              // Filter Indicator
              if (provider.hasActiveFilters) _buildFilterIndicator(context, provider),
              
              // Posts List
              _buildPostsList(context, provider),
            ],
          );
        },
      ),
    );
  }
  
  /// Build modern app bar with actions
  Widget _buildAppBar(BuildContext context, WordPressProvider provider) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      floating: true,
      snap: true,
      title: Text(
        WordPressConfig.appName,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      actions: [
        // Search toggle
        IconButton(
          icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
          tooltip: _isSearchVisible ? 'Close Search' : 'Search Posts',
          onPressed: () => _toggleSearch(provider),
        ),
        
        // Categories
        IconButton(
          icon: const Icon(Icons.category_outlined),
          tooltip: 'Categories',
          onPressed: () => _showCategories(context, provider),
        ),
        
        // Refresh
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: () => provider.refreshPosts(),
        ),
        
        const SizedBox(width: AppTheme.spacingS),
      ],
    );
  }
  
  /// Build search bar
  Widget _buildSearchBar(BuildContext context, WordPressProvider provider) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: const InputDecoration(
            hintText: 'Search posts...',
            prefixIcon: Icon(Icons.search),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (query) => provider.searchPosts(query),
          onChanged: (query) {
            // Real-time search with debouncing could be added here
            if (query.isEmpty) {
              provider.clearSearch();
            }
          },
        ),
      ),
    );
  }
  
  /// Build filter indicator
  Widget _buildFilterIndicator(BuildContext context, WordPressProvider provider) {
    final theme = Theme.of(context);
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Text(
                provider.currentFilterDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => provider.clearAllFilters(),
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build posts list with pagination
  Widget _buildPostsList(BuildContext context, WordPressProvider provider) {
    return PagedSliverList<int, Post>(
      pagingController: provider.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: (context, post, index) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppTheme.spacingM,
            index == 0 ? AppTheme.spacingM : AppTheme.spacingS,
            AppTheme.spacingM,
            AppTheme.spacingS,
          ),
          child: PostCard(post: post),
        ),
        
        // First page loading
        firstPageProgressIndicatorBuilder: (_) => const LoadingWidget(
          message: 'Loading posts...',
        ),
        
        // New page loading
        newPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: LoadingWidget.linear(
            message: 'Loading more posts...',
          ),
        ),
        
        // First page error
        firstPageErrorIndicatorBuilder: (_) => ErrorDisplay.network(
          message: provider.error ?? 'Failed to load posts',
          onRetry: () => provider.refreshPosts(),
        ),
        
        // New page error
        newPageErrorIndicatorBuilder: (_) => Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: InlineError(
            message: 'Failed to load more posts',
            onRetry: () => provider.pagingController.retryLastFailedRequest(),
          ),
        ),
        
        // No items found
        noItemsFoundIndicatorBuilder: (_) => ErrorDisplay.notFound(
          message: 'No Posts Found',
          description: provider.hasActiveFilters
              ? 'Try adjusting your search or filter criteria.'
              : 'No posts are available at the moment.',
          onRetry: provider.hasActiveFilters
              ? () => provider.clearAllFilters()
              : () => provider.refreshPosts(),
        ),
      ),
    );
  }
  
  /// Toggle search visibility
  void _toggleSearch(WordPressProvider provider) {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        // Focus search field when showing
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _searchFocusNode.requestFocus();
        });
      } else {
        // Clear search when hiding
        _searchController.clear();
        provider.clearSearch();
        _searchFocusNode.unfocus();
      }
    });
  }
  
  /// Show categories bottom sheet
  void _showCategories(BuildContext context, WordPressProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => CategoriesScreen(
        onCategorySelected: (category) {
          provider.filterByCategory(category);
          Navigator.pop(context);
        },
      ),
    );
  }
}