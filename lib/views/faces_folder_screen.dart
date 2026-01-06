import 'dart:io';
import 'package:flutter/material.dart';

import '../utils/storage_utils.dart';
import 'face_images_screen.dart';

class FacesFolderScreen extends StatefulWidget {
  const FacesFolderScreen({super.key});

  @override
  State<FacesFolderScreen> createState() => _FacesFolderScreenState();
}

class _FacesFolderScreenState extends State<FacesFolderScreen> {
  List<Directory> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  void _loadFolders() {
    final Directory faceCropsDir = Directory(
      '${StorageUtils.getPicturesDirectory().path}/FaceCrops',
    );

    if (!faceCropsDir.existsSync()) {
      setState(() => _folders = []);
      return;
    }

    final List<Directory> validFolders = [];

    for (final entity in faceCropsDir.listSync()) {
      if (entity is Directory) {
        final imageCount = _countImages(entity);

        if (imageCount == 0) {
          // 🔥 delete empty folder instantly
          try {
            entity.deleteSync(recursive: true);
          } catch (_) {}
        } else {
          validFolders.add(entity);
        }
      }
    }

    // Latest first
    validFolders.sort((a, b) => b.path.compareTo(a.path));

    setState(() {
      _folders = validFolders;
    });
  }

  int _countImages(Directory dir) {
    int count = 0;
    for (var entity in dir.listSync(recursive: true)) {
      if (entity is File &&
          (entity.path.endsWith('.jpg') ||
              entity.path.endsWith('.png') ||
              entity.path.endsWith('.jpeg'))) {
        count++;
      }
    }
    return count;
  }

  Future<void> _deleteFolder(Directory folder) async {
    try {
      if (folder.existsSync()) {
        await folder.delete(recursive: true);
      }
      _loadFolders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Folder "${folder.path.split('/').last}" deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete folder: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Crop Folders')),
      body:
          _folders.isEmpty
              ? const Center(child: Text('No face crop folders found'))
              : ListView.builder(
                itemCount: _folders.length,
                itemBuilder: (context, index) {
                  final folder = _folders[index];
                  final folderName = folder.path.split('/').last;
                  final imageCount = _countImages(folder);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.folder, size: 20),
                      title: Text(
                        folderName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '$imageCount images',
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Delete Folder'),
                                  content: Text(
                                    'Are you sure you want to delete "$folderName"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        _deleteFolder(folder);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FaceImagesScreen(folder: folder),
                          ),
                        );

                        _loadFolders();
                      },
                    ),
                  );
                },
              ),
    );
  }
}

