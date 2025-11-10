import 'package:equatable/equatable.dart';
import '../../../core/repositories/image_palette.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageFetchRequested extends ImageEvent {
  const ImageFetchRequested();
}

class ImagePaletteExtracted extends ImageEvent {
  final ImagePalette imagePalette;
  final String imageUrl;

  const ImagePaletteExtracted({
    required this.imagePalette,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [imagePalette, imageUrl];
}

