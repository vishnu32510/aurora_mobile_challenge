import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ImageState extends Equatable {
  final String? imageUrl;
  final bool isLoading;
  final String? errorMessage;
  final Color? backgroundColor;

  const ImageState({
    this.imageUrl,
    this.isLoading = false,
    this.errorMessage,
    this.backgroundColor,
  });

  ImageState copyWith({
    String? imageUrl,
    bool? isLoading,
    String? errorMessage,
    Color? backgroundColor,
  }) {
    return ImageState(
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  List<Object?> get props => [imageUrl, isLoading, errorMessage, backgroundColor];
}

