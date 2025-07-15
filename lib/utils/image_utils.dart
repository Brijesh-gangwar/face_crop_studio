import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Future<int> cropFaces({
    required img.Image originalImage,
    required List<Face> faces,
    required Directory saveDir,
  }) async {
    int count = 0;

    for (Face face in faces) {
      final rect = face.boundingBox;

      final left = rect.left < 0 ? 0 : rect.left.toInt();
      final top = rect.top < 0 ? 0 : rect.top.toInt();
      final right = rect.right.toInt() > originalImage.width
          ? originalImage.width
          : rect.right.toInt();
      final bottom = rect.bottom.toInt() > originalImage.height
          ? originalImage.height
          : rect.bottom.toInt();

      final width = right - left;
      final height = bottom - top;

      if (width <= 0 || height <= 0) continue;

      final croppedFace = img.copyCrop(
        originalImage,
        x: left,
        y: top,
        width: width,
        height: height,
      );

      final faceFile = File('${saveDir.path}/face_$count.png')
        ..writeAsBytesSync(img.encodePng(croppedFace));
      count++;
    }
    return count;
  }
}

