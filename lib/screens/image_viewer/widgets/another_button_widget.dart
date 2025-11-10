import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../modules/image/image.dart';
import '../utils/color_utils.dart';

class AnotherButtonWidget extends StatelessWidget {
  final ImageState state;
  final Color backgroundColor;
  final bool isDarkMode;

  const AnotherButtonWidget({
    super.key,
    required this.state,
    required this.backgroundColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = ColorUtils.calculateButtonColor(backgroundColor, isDarkMode);
    final textColor = ColorUtils.calculateTextColor(buttonColor);

    return Semantics(
      label: 'Load another random image',
      button: true,
      enabled: !state.isLoading,
      child: SizedBox(
        width: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () {
                    context.read<ImageBloc>().add(const ImageFetchRequested());
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
              elevation: 2,
            ),
            child: const Text(
              'Another',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
