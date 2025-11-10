import 'package:flutter/material.dart';
import '../../../modules/image/image.dart';
import 'loading_state_widget.dart';
import 'error_state_widget.dart';
import 'image_widget.dart';

class ImageContentWidget extends StatelessWidget {
  final ImageState state;

  const ImageContentWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.imageUrl == null) {
      return const LoadingStateWidget();
    }

    if (state.errorMessage != null && state.imageUrl == null) {
      return ErrorStateWidget(errorMessage: state.errorMessage!);
    }

    if (state.imageUrl != null) {
      return ImageWidget(imageUrl: state.imageUrl!);
    }

    return const LoadingStateWidget();
  }
}
