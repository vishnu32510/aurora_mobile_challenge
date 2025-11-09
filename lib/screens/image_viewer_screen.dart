import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/service_locator.dart';
import '../core/repositories/image_repository.dart';
import '../modules/image/image.dart';
import '../modules/theme/theme.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageBloc(
        imageRepository: getIt<ImageRepository>(),
      )..add(const ImageFetchRequested()),
      child: const _ImageViewerContent(),
    );
  }
}

class _ImageViewerContent extends StatelessWidget {
  const _ImageViewerContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        // Get background color, defaulting to theme-based color
        final backgroundColor = state.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: const [
              ThemeChangeDropdownButton(),
              SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              color: backgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Square image container
                      Expanded(
                        flex: 3,
                        child: _buildImageContent(context, state),
                      ),
                      const SizedBox(height: 32),
                      // "Another" button
                      _buildAnotherButton(context, state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContent(BuildContext context, ImageState state) {
    if (state.isLoading && state.imageUrl == null) {
      return _buildLoadingState(context);
    }

    if (state.errorMessage != null && state.imageUrl == null) {
      return _buildErrorState(context, state.errorMessage!);
    }

    if (state.imageUrl != null) {
      return _buildImage(context, state);
    }

    return _buildLoadingState(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    return Semantics(
      label: 'Loading image',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading image...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Semantics(
      label: 'Error loading image: $errorMessage',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading image',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, ImageState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = (screenWidth - 48).clamp(200.0, 400.0);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Semantics(
        key: ValueKey(state.imageUrl),
        label: 'Random image from Unsplash',
        image: true,
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: state.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 100),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnotherButton(BuildContext context, ImageState state) {
    return Semantics(
      label: 'Load another random image',
      button: true,
      enabled: !state.isLoading,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<ImageBloc>().add(const ImageFetchRequested());
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            disabledBackgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.5),
          ),
          child: state.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Another',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

