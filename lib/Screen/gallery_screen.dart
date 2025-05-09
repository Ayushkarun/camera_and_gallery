import 'package:flutter/material.dart';
import 'dart:io';
import 'fullimage_screen.dart';
import 'package:path_provider/path_provider.dart';

class Galleryscreen extends StatefulWidget {
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

    List<File> imgs = files
        .where((file) => file.path.endsWith(".jpg") || file.path.endsWith(".png"))
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black), // Added missing comma here
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: existingImages.map((image) {
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullimageScreen(imageFile: image),
                  ),
                );

                if (result == true) {
                  loadImages();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(image, fit: BoxFit.cover),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}