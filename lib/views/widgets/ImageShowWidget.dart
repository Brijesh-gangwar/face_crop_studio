import 'dart:io';
import 'package:flutter/material.dart';

class ImageShowWidget extends StatelessWidget {
  final File file;

  const ImageShowWidget({super.key, required this.file});

   String _getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }


  @override
  Widget build(BuildContext context) {
     final String fileName = file.path.split('/').last; 
      final String fileSize = _getFileSize(file);
    return Scaffold(
      backgroundColor: Colors.black,
     appBar: AppBar(
        backgroundColor: Colors.grey[850], 
        title: Text(
          '$fileName ($fileSize)',
          style: const TextStyle(color: Colors.white), 
        ),
        
        iconTheme: const IconThemeData(color: Colors.white), 
      ), body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(file),
        ),
      ),
    );
  }
}
