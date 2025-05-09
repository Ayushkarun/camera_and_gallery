import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';

class WelcomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  const WelcomeScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photocapture App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Camerascreen(cameras: cameras),
              ),
            );
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Open Camera'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}