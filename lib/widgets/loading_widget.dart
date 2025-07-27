import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modern loading widget with different variants
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showMessage;
  final LoadingVariant variant;
  
  const LoadingWidget({
    super.key,
    this.message,
    this.showMessage = true,
    this.variant = LoadingVariant.circular,
  });
  
  const LoadingWidget.linear({
    super.key,
    this.message,
    this.showMessage = true,
  }) : variant = LoadingVariant.linear;
  
  const LoadingWidget.shimmer({
    super.key,
    this.message,
    this.showMessage = false,
  }) : variant = LoadingVariant.shimmer;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case LoadingVariant.circular:
        return _buildCircularLoading(theme);
      case LoadingVariant.linear:
        return _buildLinearLoading(theme);
      case LoadingVariant.shimmer:
        return _buildShimmerLoading(theme);
    }
  }
  
  Widget _buildCircularLoading(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: AppTheme.spacingM),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildLinearLoading(ThemeData theme) {
    return Column(
      children: [
        LinearProgressIndicator(
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceVariant,
        ),
        if (showMessage && message != null) ...[
          const SizedBox(height: AppTheme.spacingS),
          Text(
            message!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
  
  Widget _buildShimmerLoading(ThemeData theme) {
    return _ShimmerPostCard(theme: theme);
  }
}

/// Shimmer loading for post cards
class _ShimmerPostCard extends StatefulWidget {
  final ThemeData theme;
  
  const _ShimmerPostCard({required this.theme});
  
  @override
  State<_ShimmerPostCard> createState() => _ShimmerPostCardState();
}

class _ShimmerPostCardState extends State<_ShimmerPostCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_animationController);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return _buildShimmerContainer(
                  width: double.infinity,
                  height: 200,
                );
              },
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Categories placeholder
            Row(
              children: [
                _buildShimmerContainer(width: 60, height: 24),
                const SizedBox(width: AppTheme.spacingS),
                _buildShimmerContainer(width: 80, height: 24),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Title placeholder
            _buildShimmerContainer(width: double.infinity, height: 24),
            const SizedBox(height: AppTheme.spacingS),
            _buildShimmerContainer(width: 200, height: 24),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Excerpt placeholder
            _buildShimmerContainer(width: double.infinity, height: 16),
            const SizedBox(height: AppTheme.spacingS),
            _buildShimmerContainer(width: double.infinity, height: 16),
            const SizedBox(height: AppTheme.spacingS),
            _buildShimmerContainer(width: 150, height: 16),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Footer placeholder
            Row(
              children: [
                _buildShimmerContainer(width: 80, height: 16),
                const Spacer(),
                _buildShimmerContainer(width: 100, height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildShimmerContainer({
    required double width,
    required double height,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.theme.colorScheme.surfaceVariant.withOpacity(0.3),
                widget.theme.colorScheme.surfaceVariant.withOpacity(0.7),
                widget.theme.colorScheme.surfaceVariant.withOpacity(0.3),
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Loading variants
enum LoadingVariant {
  circular,
  linear,
  shimmer,
}

/// Shimmer placeholder for lists
class ShimmerList extends StatelessWidget {
  final int itemCount;
  
  const ShimmerList({
    super.key,
    this.itemCount = 3,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacingM),
      itemBuilder: (context, index) => const LoadingWidget.shimmer(),
    );
  }
}