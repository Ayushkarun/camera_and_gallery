import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'dart:io';
import 'fullimage_screen.dart';
import 'package:path_provider/path_provider.dart'; // Don't forget this!

class Galleryscreen extends StatefulWidget {
  ///final List<File> images;
  ///const Galleryscreen({Key? key, required this.images}) : super(key: key);
  const Galleryscreen({Key? key}) : super(key: key);

  @override
  State<Galleryscreen> createState() => _GalleryscreenState();
}

class _GalleryscreenState extends State<Galleryscreen> {
  List<File> existingImages = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    List<File> imgs =
        files
            .where(
              (file) =>
                  file.path.endsWith(".jpg") || file.path.endsWith(".png"),
            )
            .map((file) => File(file.path))
            .toList();
  imgs = imgs.reversed.toList();
    setState(() {
      existingImages = imgs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children:
            existingImages.map((image) {
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullimageScreen(imageFile: image),
                    ),
                  );

                  if (result == true) {
                    // If the image was deleted, refresh the list
                    loadImages();
                  }
                },
                child: Image.file(image, fit: BoxFit.cover),
              );
            }).toList(),
      ),
    );
  }
}
