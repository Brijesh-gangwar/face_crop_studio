import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/face_detection_viewmodel.dart';
import '../utils/snackbar_util.dart';

class FaceDetectionScreen extends StatelessWidget {
  const FaceDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FaceDetectionViewModel>(
      builder: (_, vm, __) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text("Face Detection"),
                actions: [
              
                  IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    onPressed: () async {
                      await vm.switchCamera();
                    },
                  ),
                ],
              ),
              body: vm.isCameraInitialized && vm.cameraController != null
                  ? CameraPreview(vm.cameraController!)
                  : const Center(child: CircularProgressIndicator()),
              floatingActionButton: FloatingActionButton(
                onPressed: vm.isProcessing
                    ? null
                    : () async {
                        final result = await vm.captureAndDetectFaces();

                        if (result == null || result.count == 0) {
                          showSnackBar(
                            context: context,
                            message:
                                'No faces detected. Please try again.',
                          );
                        } else {
                          showSnackBar(
                            context: context,
                            message:
                                '${result.count} faces saved successfully',
                          );
                          Navigator.pop(context);
                        }
                      },
                child: const Icon(Icons.camera_alt),
              ),
            ),

            
            if (vm.isProcessing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
