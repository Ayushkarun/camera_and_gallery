import 'package:flutter/material.dart';
import 'Screen/camera_screen.dart';
import 'package:camera/camera.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();// Makes sure Flutter is ready
  final cameras = await availableCameras(); //Get list of available cameras
  runApp( MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Camera app',
      home: Camerascreen(cameras: cameras), 
    );
  }
}
