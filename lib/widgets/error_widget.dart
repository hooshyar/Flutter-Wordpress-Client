import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modern error widget with retry functionality
class ErrorDisplay extends StatelessWidget {
  final String message;
  final String? description;
  final VoidCallback? onRetry;
  final IconData? icon;
  final ErrorType type;
  
  const ErrorDisplay({
    super.key,
    required this.message,
    this.description,
    this.onRetry,
    this.icon,
    this.type = ErrorType.general,
  });
  
  const ErrorDisplay.network({
    super.key,
    this.message = 'Connection Error',
    this.description = 'Please check your internet connection and try again.',
    this.onRetry,
  }) : icon = Icons.wifi_off,
       type = ErrorType.network;
  
  const ErrorDisplay.server({
    super.key,
    this.message = 'Server Error',
    this.description = 'Something went wrong on our end. Please try again later.',
    this.onRetry,
  }) : icon = Icons.error_outline,
       type = ErrorType.server;
  
  const ErrorDisplay.notFound({
    super.key,
    this.message = 'No Content Found',
    this.description = 'We couldn\'t find any content to display.',
    this.onRetry,
  }) : icon = Icons.search_off,
       type = ErrorType.notFound;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            _buildIcon(theme),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Title
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                color: _getErrorColor(theme),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Description
            if (description != null) ...[
              const SizedBox(height: AppTheme.spacingS),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // Retry button
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingL),
              _buildRetryButton(theme),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildIcon(ThemeData theme) {
    final iconData = icon ?? _getDefaultIcon();
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: _getErrorColor(theme).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 64,
        color: _getErrorColor(theme),
      ),
    );
  }
  
  Widget _buildRetryButton(ThemeData theme) {
    return FilledButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh),
      label: const Text('Try Again'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingL,
          vertical: AppTheme.spacingM,
        ),
      ),
    );
  }
  
  Color _getErrorColor(ThemeData theme) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.server:
        return theme.colorScheme.error;
      case ErrorType.notFound:
        return theme.colorScheme.primary;
      case ErrorType.general:
      default:
        return theme.colorScheme.error;
    }
  }
  
  IconData _getDefaultIcon() {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.server:
        return Icons.error_outline;
      case ErrorType.notFound:
        return Icons.search_off;
      case ErrorType.general:
      default:
        return Icons.error_outline;
    }
  }
}

/// Inline error widget for smaller spaces
class InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final EdgeInsets padding;
  
  const InlineError({
    super.key,
    required this.message,
    this.onRetry,
    this.padding = const EdgeInsets.all(AppTheme.spacingM),
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppTheme.spacingS),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error types for different styling
enum ErrorType {
  general,
  network,
  server,
  notFound,
}