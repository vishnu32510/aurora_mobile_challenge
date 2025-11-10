import 'package:bloc/bloc.dart';
import '../../core/repositories/image_repository.dart';
import '../../core/utils/logger.dart';
import 'image_event.dart';
import 'image_state.dart';



class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;

  ImageBloc({
    required ImageRepository imageRepository,
  })  : _imageRepository = imageRepository,
        super(const ImageState()) {
    on<ImageFetchRequested>(_onImageFetchRequested);
    on<ImagePaletteExtracted>(_onImagePaletteExtracted);
  }

  Future<void> _onImageFetchRequested(
    ImageFetchRequested event,
    Emitter<ImageState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      clearImageUrl: true,
    ));

    try {
      final imageResponse = await _imageRepository.fetchRandomImage();
      
      emit(state.copyWith(
        imageUrl: imageResponse.url,
        isLoading: false,
      ));
      
        _imageRepository.extractImagePalette(imageResponse.url).then((imagePalette) {
          if (!isClosed) {
            add(ImagePaletteExtracted(
              imagePalette: imagePalette,
              imageUrl: imageResponse.url,
            ));
          }
        }).catchError((error, stackTrace) {
          AppLogger.error('Failed to extract image palette', error, stackTrace);
        });
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch random image', e, stackTrace);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onImagePaletteExtracted(
    ImagePaletteExtracted event,
    Emitter<ImageState> emit,
  ) {
    if (state.imageUrl == event.imageUrl) {
      emit(state.copyWith(imagePalette: event.imagePalette));
    }
  }



}

