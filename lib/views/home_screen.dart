import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/permissions_utils.dart';
import '../view_models/face_detection_viewmodel.dart';
import 'face_detection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    PermissionsUtils.requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FaceDetectionViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Face Detection Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Start Camera'),
              onPressed: () async {
                await vm.initCamera();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FaceDetectionScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Open Last Folder'),
              onPressed: () => vm.openFacesFolder(context),
            ),
          ],
        ),
      ),
    );
  }
}
