import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:camera_app_new/main.dart';
import 'gallery_screen.dart';

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

  late CameraController _controller; //to control the camera
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
            flex: 12,
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
          Spacer(),
          Expanded(
            flex: 2,
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
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _initializeControllerFuture;

                      final xFile = await _controller.takePicture();

                      // Save it to app's document directory
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
                      height: 260,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (capturedImage.isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Galleryscreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 90,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        image:
                            capturedImage.isNotEmpty
                                ? DecorationImage(
                                  image: FileImage(capturedImage.last),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
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
