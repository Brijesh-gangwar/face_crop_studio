import 'dart:io';

class StorageUtils {
  static Directory getPicturesDirectory() {
    return Directory('/storage/emulated/0/Pictures');
  }

  static Directory getFaceCropsDirectory() {
    final dir = Directory('${getPicturesDirectory().path}/FaceCrops');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }


  static Directory createFaceCropFolder() {
    final Directory faceCropsDir = getFaceCropsDirectory();

    final DateTime now = DateTime.now();

    final String formattedTimestamp =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}-'
        '${now.minute.toString().padLeft(2, '0')}-'
        '${now.second.toString().padLeft(2, '0')}';

    final Directory captureDir =
        Directory('${faceCropsDir.path}/capture_$formattedTimestamp');

    if (!captureDir.existsSync()) {
      captureDir.createSync(recursive: true);
    }

    return captureDir;
  }
}
