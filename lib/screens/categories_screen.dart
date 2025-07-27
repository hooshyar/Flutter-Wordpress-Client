import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart' as wp;
import '../providers/wordpress_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../theme/app_theme.dart';

/// Categories screen for filtering posts
class CategoriesScreen extends StatelessWidget {
  final void Function(wp.WPCategory?)? onCategorySelected;
  final bool showAsBottomSheet;
  
  const CategoriesScreen({
    super.key,
    this.onCategorySelected,
    this.showAsBottomSheet = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<WordPressProvider>(
      builder: (context, provider, _) {
        if (showAsBottomSheet) {
          return _buildBottomSheet(context, provider);
        } else {
          return _buildFullScreen(context, provider);
        }
      },
    );
  }
  
  /// Build as bottom sheet
  Widget _buildBottomSheet(BuildContext context, WordPressProvider provider) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusL),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppTheme.spacingS),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              _buildHeader(context, provider),
              
              // Content
              Expanded(
                child: _buildContent(context, provider, scrollController),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build as full screen
  Widget _buildFullScreen(BuildContext context, WordPressProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          if (provider.selectedCategory != null)
            TextButton(
              onPressed: () => _selectCategory(context, provider, null),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: _buildContent(context, provider, null),
    );
  }
  
  /// Build header
  Widget _buildHeader(BuildContext context, WordPressProvider provider) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Text(
            'Categories',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (provider.selectedCategory != null)
            TextButton(
              onPressed: () => _selectCategory(context, provider, null),
              child: const Text('Clear Filter'),
            ),
        ],
      ),
    );
  }
  
  /// Build content
  Widget _buildContent(
    BuildContext context,
    WordPressProvider provider,
    ScrollController? scrollController,
  ) {
    if (provider.isLoading && !provider.hasCategories) {
      return const LoadingWidget(
        message: 'Loading categories...',
      );
    }
    
    if (provider.hasError && !provider.hasCategories) {
      return ErrorDisplay(
        message: provider.error ?? 'Failed to load categories',
        onRetry: () => provider.loadCategories(),
      );
    }
    
    if (!provider.hasCategories) {
      return const ErrorDisplay.notFound(
        message: 'No Categories Found',
        description: 'Categories will appear here when available.',
      );
    }
    
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      children: [
        // Featured Categories
        if (provider.featuredCategories.isNotEmpty) ...[
          _buildSectionHeader(context, 'Featured Categories'),
          const SizedBox(height: AppTheme.spacingS),
          ...provider.featuredCategories.map(
            (category) => _buildCategoryTile(context, provider, category),
          ),
          const SizedBox(height: AppTheme.spacingL),
        ],
        
        // All Categories
        _buildSectionHeader(context, 'All Categories'),
        const SizedBox(height: AppTheme.spacingS),
        ...provider.categories.map(
          (category) => _buildCategoryTile(context, provider, category),
        ),
        
        const SizedBox(height: AppTheme.spacingL),
      ],
    );
  }
  
  /// Build section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
  
  /// Build category tile
  Widget _buildCategoryTile(
    BuildContext context,
    WordPressProvider provider,
    wp.WPCategory category,
  ) {
    final theme = Theme.of(context);
    final isSelected = provider.selectedCategory?.id == category.id;
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingXS,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Text(
            '${category.count}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: category.description.isNotEmpty
            ? Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              )
            : null,
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              )
            : const Icon(Icons.chevron_right),
        selected: isSelected,
        onTap: () => _selectCategory(
          context,
          provider,
          isSelected ? null : category,
        ),
      ),
    );
  }
  
  /// Handle category selection
  void _selectCategory(
    BuildContext context,
    WordPressProvider provider,
    wp.WPCategory? category,
  ) {
    if (onCategorySelected != null) {
      onCategorySelected!(category);
    } else {
      provider.filterByCategory(category);
      if (showAsBottomSheet) {
        Navigator.pop(context);
      }
    }
  }
}