import 'dart:io';
import 'package:flutter/material.dart';

import 'widgets/ImageShowWidget.dart';

class FaceImagesScreen extends StatefulWidget {
  final Directory folder;

  const FaceImagesScreen({super.key, required this.folder});

  @override
  State<FaceImagesScreen> createState() => _FaceImagesScreenState();
}

class _FaceImagesScreenState extends State<FaceImagesScreen> {
  late List<File> images;

  @override
  void initState() {
    super.initState();
    images = _loadImages(widget.folder);
  }


  List<File> _loadImages(Directory dir) {
    List<File> imgs = [];
    for (var entity in dir.listSync()) {
      if (entity is File &&
          (entity.path.endsWith('.jpg') ||
              entity.path.endsWith('.png') ||
              entity.path.endsWith('.jpeg'))) {
        imgs.add(entity);
      } else if (entity is Directory) {
        imgs.addAll(_loadImages(entity));
      }
    }


    imgs.sort((a, b) => b.path.compareTo(a.path));
    return imgs;
  }

  Future<void> _deleteImage(File image) async {
    try {
      if (image.existsSync()) {
        await image.delete();
      }
      setState(() {
        images.remove(image); 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String folderName = widget.folder.path.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              folderName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${images.length} images',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: images.isEmpty
          ? const Center(child: Text('No images found in this folder'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final imgFile = images[index];

                return Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ImageShowWidget(file: imgFile),
                            ),
                          );
                        },
                        child: Image.file(
                          imgFile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // 🔴 Delete button (top-right)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Image'),
                              content: const Text(
                                  'Are you sure you want to delete this image?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _deleteImage(imgFile);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
