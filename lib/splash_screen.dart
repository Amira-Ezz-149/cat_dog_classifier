import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cat_dog_classifier/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      AnimatedSplashScreen(

        backgroundColor: Colors.amber,
        splashIconSize: 200.0,
        splash: Container(
          child: Image.asset('assets/cat_dog_icon.png', fit: BoxFit.cover),
        ),
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.scaleTransition,
    );
  }
}
