import 'dart:io';
import 'dart:ui';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.75,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/cat_dog_tflite/model_unquant.tflite',
        labels: 'assets/cat_dog_tflite/labels.txt');
  }

  void initState() {
    loadModel().then((value) {
      setState(() {});
    });
    super.initState();
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = false;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickCameraImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = false;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Teachable Machine",
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: _loading
                ? Container(
                    height: 250,
                    child: Image.asset("assets/images/default_img.png"))
                : Container(
                    height: 250,
                    child: Image.file(_image),
                  ),
          ),
          Container(
              child: _output != null
                  ? Text(
                      '${_output[0]['label']}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  : Text('')),
          SizedBox(
            height: 60,
          ),
          FlatButton(
            onPressed: () {
              pickCameraImage();
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFE99600),
                  borderRadius: BorderRadius.circular(6.0)),
              child: Text(
                "Take Photo",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: () {
              pickGalleryImage();
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFE99600),
                  borderRadius: BorderRadius.circular(6.0)),
              child: Text(
                "Camera Roll",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
