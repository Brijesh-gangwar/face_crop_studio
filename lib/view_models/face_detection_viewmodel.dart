import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../models/face_crop_result.dart';
import '../utils/permissions_utils.dart';
import '../utils/image_utils.dart';
import '../utils/storage_utils.dart';
import '../views/face_images_screen.dart';

class FaceDetectionViewModel extends ChangeNotifier {
  final List<CameraDescription> cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  Directory? _savedFacesDir;

  int _currentCameraIndex = 0; 

  bool get isCameraInitialized => _isCameraInitialized;
  bool get isProcessing => _isProcessing;
  CameraController? get cameraController => _cameraController;
  int get currentCameraIndex => _currentCameraIndex;

  FaceDetectionViewModel(this.cameras);

  // ----------------- Permissions -----------------
  Future<void> requestPermissions() async {
    await PermissionsUtils.requestStoragePermission();
  }

  // ----------------- Initialize Camera -----------------
  Future<void> initCamera({int cameraIndex = 0}) async {
    if (cameras.isEmpty) return;

    _currentCameraIndex = cameraIndex;

    _cameraController = CameraController(
      cameras[_currentCameraIndex],
      ResolutionPreset.max,
    );

    await _cameraController!.initialize();
    _isCameraInitialized = true;
    notifyListeners();
  }

  // ----------------- Switch Camera -----------------
  Future<void> switchCamera() async {
    if (cameras.length < 2) return; // only one camera available

    _isCameraInitialized = false;
    notifyListeners();

    await _cameraController?.dispose();

    // switch camera index
    _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;

    _cameraController = CameraController(
      cameras[_currentCameraIndex],
      ResolutionPreset.max,
    );

    await _cameraController!.initialize();
    _isCameraInitialized = true;
    notifyListeners();
  }

  // ----------------- Capture & Detect Faces -----------------
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

      final Directory captureDir = StorageUtils.createFaceCropFolder();

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

  // ----------------- Open Latest Folder -----------------
  Future<void> openFacesFolder(BuildContext context) async {
    final Directory faceCropsDir = StorageUtils.getFaceCropsDirectory();

    if (!faceCropsDir.existsSync()) {
      _showSnack(context, 'No FaceCrops folder found');
      return;
    }

    final List<Directory> captureFolders = faceCropsDir
        .listSync()
        .whereType<Directory>()
        .toList();

    if (captureFolders.isEmpty) {
      _showSnack(context, 'No capture folders yet');
      return;
    }

    
    captureFolders.sort(
      (a, b) => b.path.compareTo(a.path),
    );

    final Directory latestFolder = captureFolders.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FaceImagesScreen(folder: latestFolder),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  
  void disposeCamera() {
    _cameraController?.dispose();
  }
}
