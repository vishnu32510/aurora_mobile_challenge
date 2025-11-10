import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/image/image.dart';
import '../modules/theme/theme.dart';
import 'image_viewer/image_viewer.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            // Determine if we're in dark mode
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            
            // Get background gradient, defaulting to theme-based color
            final gradient = state.imagePalette?.toGradient() ??
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                );
            
            final dominantColor = state.imagePalette?.dominantColor ??
                Theme.of(context).scaffoldBackgroundColor;

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: SafeArea(
                  minimum: EdgeInsets.zero,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(alignment: Alignment.topRight, child: const ThemeChangeButton()),
                          // Square image container
                          Expanded(
                            flex: 3,
                            child: ImageContentWidget(state: state),
                          ),
                          const SizedBox(height: 32),
                          // "Another" button
                          AnotherButtonWidget(
                            state: state,
                            backgroundColor: dominantColor,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

