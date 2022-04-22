import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  File? _image;
  List? _output;
  final _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  void _detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    _detectImage(_image!);
  }

  pickGalleryImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    _detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              const SizedBox(height: 5.0),
              const Text(
                'Cats and Dogs Detector App',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 50.0),
              Center(
                child: _loading
                    ? SizedBox(
                        width: 400.0,
                        child: Column(
                          children: [
                            Image.asset('assets/cat_dog_icon.png'),
                            const SizedBox(
                              height: 50.0,
                            ),
                          ],
                        ),
                      )
                    :  Column(
                  children: [
                    SizedBox(
                      height: 250.0,
                      child: Image.file(_image!)
                    ),
                    const SizedBox(height: 20.0,),
                    _output!= null ?  Text('${_output![0]['label']}', style: TextStyle(color: Colors.white, fontSize: 20.0),): Container(),
                 SizedBox(height: 20.0,),
                  ],
                ),

              ),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Text(
                    'Capture a photo',
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              GestureDetector(
                onTap: () {
                  pickGalleryImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width ,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Text(
                    'Select a photo',
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                ),
              ),

             const SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }
}
