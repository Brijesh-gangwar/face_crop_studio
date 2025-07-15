import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';


import 'view_models/face_detection_viewmodel.dart';
import 'views/home_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final camerasList = await availableCameras();

  runApp(
    MultiProvider(
      providers: [
        Provider<List<CameraDescription>>.value(value: camerasList),
        ChangeNotifierProvider(
          create: (context) =>
              FaceDetectionViewModel(context.read<List<CameraDescription>>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Detection MVVM',
      home: HomeScreen(),
    );
  }
}
