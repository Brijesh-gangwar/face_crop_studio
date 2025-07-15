import 'dart:io';

class StorageUtils {
  static Directory getPicturesDirectory() {
    return Directory('/storage/emulated/0/Pictures');
  }

  static Directory createFaceCropFolder(String timestamp) {
    final Directory picturesDir = getPicturesDirectory();
    final Directory faceCropsDir = Directory('${picturesDir.path}/FaceCrops');
    if (!faceCropsDir.existsSync()) {
      faceCropsDir.createSync(recursive: true);
    }

    final Directory captureDir = Directory('${faceCropsDir.path}/capture_$timestamp');
    if (!captureDir.existsSync()) {
      captureDir.createSync(recursive: true);
    }
    return captureDir;
  }
}
