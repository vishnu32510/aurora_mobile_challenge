import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import '../../core/repositories/image_repository.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;

  ImageBloc({required ImageRepository imageRepository})
      : _imageRepository = imageRepository,
        super(const ImageState()) {
    on<ImageFetchRequested>(_onImageFetchRequested);
  }

  Future<void> _onImageFetchRequested(
    ImageFetchRequested event,
    Emitter<ImageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final imageResponse = await _imageRepository.fetchRandomImage();
      
      // Extract dominant color from the image
      final backgroundColor = await _extractDominantColor(imageResponse.url);
      
      emit(state.copyWith(
        imageUrl: imageResponse.url,
        isLoading: false,
        backgroundColor: backgroundColor,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<Color> _extractDominantColor(String imageUrl) async {
    try {
      // Fetch image bytes
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        return Colors.grey.shade300;
      }

      final Uint8List bytes = response.bodyBytes;
      
      // Decode image
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Use palette_generator to extract dominant color
      final paletteGenerator = await PaletteGenerator.fromImage(image);
      final dominantColor = paletteGenerator.dominantColor?.color;

      // Dispose the image
      image.dispose();

      if (dominantColor != null) {
        // Make the color slightly darker for better contrast with the image
        return Color.fromRGBO(
          ((dominantColor.r * 255.0) * 0.7).round().clamp(0, 255),
          ((dominantColor.g * 255.0) * 0.7).round().clamp(0, 255),
          ((dominantColor.b * 255.0) * 0.7).round().clamp(0, 255),
          1.0,
        );
      }

      return Colors.grey.shade300;
    } catch (e) {
      // If color extraction fails, return a default color
      return Colors.grey.shade300;
    }
  }
}

