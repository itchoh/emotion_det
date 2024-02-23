import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

import 'main.dart';

class Emotion extends StatefulWidget {
  const Emotion({super.key});

  @override
  State<Emotion> createState() => _State();
}

class _State extends State<Emotion> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  double ou = 0;
  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((image) {
            cameraImage=image;
            runModel(image);
          });
        });
      }
    });
  }
  runModel(CameraImage img) async {
    if (cameraImage!=null) {
      dynamic recognitions = await Tflite.runModelOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(), // required
          imageHeight: img.height,
          imageWidth: img.width,
          imageMean: 127.5, // defaults to 127.5
          imageStd: 127.5, // defaults to 127.5
          rotation: 90, // defaults to 90, Android only
          numResults: 2, // defaults to 5
          threshold: 0.1, // defaults to 0.1
          asynch: true // defaults to true
      );
      for (var element in recognitions) {
        setState(() {
          output = element['label'];
          ou = element['confidence'] * 1000;
          ou=ou-ou%1;
          ou/=10;
        },);
      }
    }
  }
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }
  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }
  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Emotion Detector"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const SizedBox(height: 50,width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height*0.7,
                width: MediaQuery.of(context).size.width,
                child: !cameraController!.value.isInitialized?Container():AspectRatio(aspectRatio: cameraController!.value.aspectRatio,child: CameraPreview(cameraController!)),
              ),
            ),
            Text(
              output,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              "$ou%",
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
