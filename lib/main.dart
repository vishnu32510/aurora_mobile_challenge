import 'bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/repositories/image_repository.dart';
import 'core/utils/app_constants.dart';
import 'modules/image/image.dart';
import 'modules/theme/theme.dart';
import 'screens/image_viewer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupServiceLocator();
  
  Bloc.observer = SimpleBlocObserver();
  runApp(ThemeWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: AppConstants.appTitle,
          theme: state.themeData,
          themeAnimationCurve: Curves.easeInOutCubic,
          themeAnimationDuration: const Duration(milliseconds: 400),
          themeMode: state.themeMode,
          darkTheme: DarkThemeState.darkTheme.themeData,
          home: BlocProvider(
            create: (context) => ImageBloc(
              imageRepository: getIt<ImageRepository>(),
            )..add(const ImageFetchRequested()),
            child: const ImageViewerScreen(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
