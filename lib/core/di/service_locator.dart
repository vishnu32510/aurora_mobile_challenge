import 'package:get_it/get_it.dart';
import '../services/services.dart';
import '../repositories/image_repository.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // Services - Singleton (shared instance)
  getIt.registerLazySingleton<HttpServices>(() => HttpServices());

  // Repositories - Factory (new instance each time, but can share services)
  getIt.registerFactory<ImageRepository>(
    () => ImageRepository(httpServices: getIt<HttpServices>()),
  );
}

