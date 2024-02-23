import 'package:flutter/material.dart';

import 'emotion.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Emotion()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Emotion Detector', style: TextStyle(color: Colors.black, fontSize: 34,),),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.black,),
          ],
        ),
      ),
    );
  }
}
