import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPickImageScreen(title: 'Flutter Image Editor Sample'),
    );
  }
}

class MyPickImageScreen extends StatefulWidget {
  const MyPickImageScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyPickImageScreenState createState() => _MyPickImageScreenState();
}

class _MyPickImageScreenState extends State<MyPickImageScreen> {
  var imgFile;
  final imgPicker = ImagePicker();

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text("Capture Image From Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: const Text("Take Image From Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    final XFile? imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
    });
    cropImage(imgCamera!.path);
    Navigator.of(context).pop();
  }

  void openGallery() async {
    final XFile? imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    cropImage(imgGallery!.path);
    Navigator.of(context).pop();
  }

  void cropImage(filePath) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 512,
      maxWidth: 512,
      cropStyle: CropStyle.rectangle,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Edit Image',
        toolbarColor: Colors.white,
        toolbarWidgetColor: Colors.black,
        lockAspectRatio: true,
        hideBottomControls: true,
        showCropGrid: false,
        cropGridColor: Colors.transparent,
        cropFrameStrokeWidth: 0,
        dimmedLayerColor: Colors.transparent,
        cropFrameColor: Colors.transparent
      ),
    );
    if (croppedFile != null) {
      setState(() {
        imgFile = croppedFile;
      });
    }
  }

  Widget displayImage() {
    if (imgFile == null) {
      return const Text("No Image Selected!");
    } else {
      return Image.file(
        imgFile,
        height: 300,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayImage(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                showOptionsDialog(context);
              },
              child: const Text("Select Image"),
            ),
          ],
        ),
      ),
    );
  }
}
