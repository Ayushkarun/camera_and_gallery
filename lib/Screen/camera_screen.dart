import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'gallery_screen.dart';
import 'fullimage_screen.dart';

class Camerascreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Camerascreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<Camerascreen> createState() => _CamerascreenState();
}

class _CamerascreenState extends State<Camerascreen> {
  @override
  void initState() {
    initializeCamera(selectedCamera);
    super.initState();
  }

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 0;
  List<File> capturedImage = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.low,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 16,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
    
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.cameras.length > 1) {
                        setState(() {
                          selectedCamera = selectedCamera == 0 ? 1 : 0;
                          initializeCamera(selectedCamera);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No secondary camera'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.switch_camera_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  if (capturedImage.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FullimageScreen(
                                  imageFile: capturedImage.last,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(capturedImage.last),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.photo,
                        color: Colors.white.withOpacity(0.5),
                        size: 30,
                      ),
                    ),
                  // Capture button
                  GestureDetector(
                    onTap: () async {
                      await _initializeControllerFuture;
                      final xFile = await _controller.takePicture();
                      final appDir = await getApplicationDocumentsDirectory();
                      final fileName = path.basename(xFile.path);
                      final savedImage = await File(
                        xFile.path,
                      ).copy('${appDir.path}/$fileName');
                      setState(() {
                        capturedImage.add(savedImage);
                      });
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white30, width: 3),
                      ),
                    ),
                  ),
                  // Gallery thumbnail
                  GestureDetector(
                    onTap: () {
                      if (capturedImage.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No photos taken yet'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Galleryscreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        image:
                            capturedImage.isNotEmpty
                                ? DecorationImage(
                                  image: FileImage(capturedImage.last),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          capturedImage.isEmpty
                              ? Icon(Icons.photo_library, color: Colors.white)
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
