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
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/flowers_tflite/model.tflite',
        labels: 'assets/flowers_tflite/labels.txt');
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
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Teachable Machine",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5))]),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _loading
                        ? Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5))
                                ]),
                            height: 200,
                            child: Image.asset("assets/images/default_img.png"))
                        : Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5))
                                ]),
                            height: 200,
                            child: Image.file(_image),
                          ),
                    Container(
                        padding: EdgeInsets.all(30),
                        child: _output != null && _output.length > 0
                            ? Text(
                                '${_output[0]['label']}',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
