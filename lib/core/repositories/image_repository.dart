import '../services/services.dart';
import '../utils/app_constants.dart';

class ImageRepository {
  final HttpServices _httpServices;

  ImageRepository({required HttpServices httpServices})
      : _httpServices = httpServices;

  Future<ImageResponse> fetchRandomImage() async {
    final url = '${AppConstants.baseUrl}/image';
    final response = await _httpServices.getMethod(url);

    // Check if response is an error
    if (response is ServiceError) {
      throw ImageFetchException(_getErrorMessage(response));
    }

    // Parse the response
    try {
      final jsonData = response as Map<String, dynamic>;
      final imageUrl = jsonData['url'] as String;
      return ImageResponse(url: imageUrl);
    } catch (e) {
      throw ImageFetchException('Failed to parse response: ${e.toString()}');
    }
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

