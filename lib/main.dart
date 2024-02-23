import 'package:camera/camera.dart';
import 'package:emotion_det/splash.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const Emotion());
}
class Emotion extends StatelessWidget {
  const Emotion({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}


