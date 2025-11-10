import '../theme.dart';
import '../theme_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeChangeButton extends StatelessWidget {
  const ThemeChangeButton({super.key});

  ThemeType _getNextTheme(ThemeType currentTheme) {
    switch (currentTheme) {
      case ThemeType.system:
        return ThemeType.lightMode;
      case ThemeType.lightMode:
        return ThemeType.darkMode;
      case ThemeType.darkMode:
        return ThemeType.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final currentTheme = state.themeEventType;
        final nextTheme = _getNextTheme(currentTheme);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: IconButton(
            key: ValueKey(currentTheme),
            icon: Icon(
              currentTheme.iconData,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            tooltip: '${currentTheme.themeName} mode, Switch to ${nextTheme.themeName} mode',
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context).add(
                ThemeEventChange(nextTheme),
              );
            },
          ),
        );
      },
    );
  }
}
