import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

class LoadingStateWidget extends StatelessWidget {
  final Color? dominantColor;

  const LoadingStateWidget({
    super.key,
    this.dominantColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading image',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
          return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ShimmerContainer(
                    borderRadius: BorderRadius.circular(12),
                    baseColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                    highlightColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade700
                        : Colors.grey.shade100,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

