import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';

import '../models/face_crop_result.dart';
import '../utils/permissions_utils.dart';
import '../utils/image_utils.dart';
import '../utils/storage_utils.dart';

class FaceDetectionViewModel extends ChangeNotifier {
  final List<CameraDescription> cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  Directory? _savedFacesDir;

  bool get isCameraInitialized => _isCameraInitialized;
  bool get isProcessing => _isProcessing;
  CameraController? get cameraController => _cameraController;

  FaceDetectionViewModel(this.cameras);

  Future<void> requestPermissions() async {
    await PermissionsUtils.requestStoragePermission();
  }

  Future<void> initCamera() async {
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );
    await _cameraController!.initialize();
    _isCameraInitialized = true;
    notifyListeners();
  }

  Future<FaceCropResult?> captureAndDetectFaces() async {
    if (!_isCameraInitialized || _cameraController == null) return null;

    _isProcessing = true;
    notifyListeners();

    try {
      final XFile file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);

      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: false,
          enableClassification: true,
          performanceMode: FaceDetectorMode.accurate,
        ),
      );

      final List<Face> faces = await faceDetector.processImage(inputImage);
      if (faces.isEmpty) {
        return FaceCropResult(count: 0, folderPath: '');
      }

      final imageBytes = await File(file.path).readAsBytes();
      final originalImage = img.decodeImage(imageBytes)!;

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final Directory captureDir = StorageUtils.createFaceCropFolder(timestamp);

      final int count = await ImageUtils.cropFaces(
        originalImage: originalImage,
        faces: faces,
        saveDir: captureDir,
      );

      _savedFacesDir = captureDir;

      return FaceCropResult(count: count, folderPath: captureDir.path);
    } catch (e) {
      debugPrint('Error in captureAndDetectFaces: $e');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> openFacesFolder(BuildContext context) async {
    if (_savedFacesDir != null && await _savedFacesDir!.exists()) {
      final files = _savedFacesDir!.listSync();
      if (files.isNotEmpty) {
        await OpenFile.open(files.first.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No files found to open.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No capture folder yet!')),
      );
    }
  }

  void disposeCamera() {
    _cameraController?.dispose();
  }
}
