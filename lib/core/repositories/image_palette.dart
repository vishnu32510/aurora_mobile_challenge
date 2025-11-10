import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ImagePalette extends Equatable {
  final List<Color> colors;
  final Color dominantColor;

  const ImagePalette({
    required this.colors,
    required this.dominantColor,
  });

  factory ImagePalette.withDefaults({
    required List<Color> colors,
    Color? dominantColor,
  }) {
    return ImagePalette(
      colors: colors,
      dominantColor: dominantColor ?? (colors.isNotEmpty ? colors.first : Colors.grey),
    );
  }

  @override
  List<Object> get props => [colors, dominantColor];


  LinearGradient toGradient() {
    if (colors.isEmpty) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.grey, Colors.grey],
      );
    }

    if (colors.length == 1) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colors.first, colors.first],
      );
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    );
  }


}

