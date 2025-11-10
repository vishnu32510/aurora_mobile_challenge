import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../services/services.dart';
import '../utils/app_constants.dart';
import '../utils/logger.dart';
import 'image_palette.dart';

class ImageRepository {
  final HttpServices _httpServices;

  ImageRepository({required HttpServices httpServices})
      : _httpServices = httpServices;

  Future<ImageResponse> fetchRandomImage() async {
    final url = '${AppConstants.baseUrl}/image';
    final response = await _httpServices.getMethod(url);

    if (response is ServiceError) {
      throw ImageFetchException(_getErrorMessage(response));
    }

    try {
      final jsonData = response as Map<String, dynamic>;
      final imageUrl = jsonData['url'] as String;
      return ImageResponse(url: imageUrl);
    } catch (e) {
      throw ImageFetchException('Failed to parse response: ${e.toString()}');
    }
  }

  Future<ImagePalette> extractImagePalette(String imageUrl) async {
    try {
      final response = await _httpServices.getBytesMethod(imageUrl);

      if (response is ServiceError) {
        return const ImagePalette(colors: [Colors.grey], dominantColor: Colors.grey);
      }

      final bytes = response as Uint8List;
      return await _processImageBytes(bytes);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to extract image palette', e, stackTrace);
      return const ImagePalette(colors: [Colors.grey], dominantColor: Colors.grey);
    }
  }

  Future<ImagePalette> _processImageBytes(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 300,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final List<Color> colors = await _sampleColorsFromImage(image);
      
      final palette = await PaletteGenerator.fromImage(image);
      final Color dominantColor = palette.dominantColor?.color ?? 
          (colors.isNotEmpty ? colors.first : Colors.grey);
      // final List<Color> paletteColors = palette.paletteColors.take(4).map((color) => color.color).toSet().toList();
      
      image.dispose();
      
      return ImagePalette(colors: colors, dominantColor: dominantColor);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to process image bytes', e, stackTrace);
      return const ImagePalette(colors: [Colors.grey], dominantColor: Colors.grey);
    }
  }

  Future<List<Color>> _sampleColorsFromImage(ui.Image image) async {
    final Set<Color> colors = {};
    final width = image.width;
    final height = image.height;
    
    final samplePositions = [0.0, 0.25, 0.5, 0.75, 1.0];
    
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      return await _getFallbackColors(image);
    }
    
    for (final position in samplePositions) {
      final y = (height * position).round().clamp(0, height - 1);
      final x = (width * 0.5).round();
      
      final pixelIndex = (y * width + x) * 4;
      
      if (pixelIndex + 3 < byteData.lengthInBytes) {
        final r = byteData.getUint8(pixelIndex);
        final g = byteData.getUint8(pixelIndex + 1);
        final b = byteData.getUint8(pixelIndex + 2);
        final a = byteData.getUint8(pixelIndex + 3);
        
        colors.add(Color.fromARGB(a, r, g, b));
      }
    }
    
    if (colors.isEmpty) {
      return await _getFallbackColors(image);
    }
    
    return colors.toList();
  }

  Future<List<Color>> _getFallbackColors(ui.Image image) async {
    final palette = await PaletteGenerator.fromImage(image);
    final Set<Color> colors = {};
    
    if (palette.lightVibrantColor != null) {
      colors.add(palette.lightVibrantColor!.color);
    }
    if (palette.vibrantColor != null) {
      colors.add(palette.vibrantColor!.color);
    }
    if (palette.darkVibrantColor != null) {
      colors.add(palette.darkVibrantColor!.color);
    }
    
    if (colors.isEmpty && palette.dominantColor != null) {
      colors.add(palette.dominantColor!.color);
    }
    
    if (colors.isEmpty) {
      colors.add(Colors.grey.shade800);
    }
    
    final colorList = colors.toList();
    if (colorList.length == 1) {
      colorList.add(colorList.first);
    }
    
    return colorList;
  }

  String _getErrorMessage(ServiceError error) {
    switch (error) {
      case ServiceError.clientError:
        return 'Client error: Invalid request';
      case ServiceError.serverError:
        return 'Server error: Please try again later';
      case ServiceError.timeoutError:
        return 'Request timeout: Please check your connection';
      case ServiceError.socketError:
        return 'Network error: Please check your internet connection';
      case ServiceError.unknownError:
      case ServiceError.unknownResponseError:
        return 'An unexpected error occurred';
    }
  }
}

class ImageResponse {
  final String url;

  ImageResponse({required this.url});
}

class ImageFetchException implements Exception {
  final String message;
  ImageFetchException(this.message);

  @override
  String toString() => message;
}

