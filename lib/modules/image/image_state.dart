import 'package:equatable/equatable.dart';
import '../../../core/repositories/image_palette.dart';

class ImageState extends Equatable {
  final String? imageUrl;
  final bool isLoading;
  final String? errorMessage;
  final ImagePalette? imagePalette;

  const ImageState({
    this.imageUrl,
    this.isLoading = false,
    this.errorMessage,
    this.imagePalette,
  });

  ImageState copyWith({
    String? imageUrl,
    bool? isLoading,
    String? errorMessage,
    ImagePalette? imagePalette,
    bool clearImagePalette = false,
    bool clearImageUrl = false,
  }) {
    return ImageState(
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      imagePalette: clearImagePalette 
          ? null 
          : (imagePalette ?? this.imagePalette),
    );
  }

  @override
  List<Object?> get props => [imageUrl, isLoading, errorMessage, imagePalette];
}

