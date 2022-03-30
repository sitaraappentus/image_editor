import 'dart:io';
import 'dart:math';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
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
  File? imgFile;
  final imgPicker = ImagePicker();
  late CustomImageCropController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
    //cropImage(imgCamera!.path);
    Navigator.of(context).pop();
  }

  void openGallery() async {
    final XFile? imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    //cropImage(imgGallery!.path);
    Navigator.of(context).pop();
  }

  /*void cropImage(filePath) {
    CustomImageCrop customImageCrop = CustomImageCrop(
      cropController: controller,
      image: AssetImage(filePath),
      shape: CustomCropShape.Circle,
    );
    if (customImageCrop != null) {
      Row(
        children: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: controller.reset),
          IconButton(icon: const Icon(Icons.zoom_in), onPressed: () => controller.addTransition(CropImageData(scale: 1.33))),
          IconButton(icon: const Icon(Icons.zoom_out), onPressed: () => controller.addTransition(CropImageData(scale: 0.75))),
          IconButton(icon: const Icon(Icons.rotate_left), onPressed: () => controller.addTransition(CropImageData(angle: -pi / 4))),
          IconButton(icon: const Icon(Icons.rotate_right), onPressed: () => controller.addTransition(CropImageData(angle: pi / 4))),
          IconButton(
            icon: const Icon(Icons.crop),
            onPressed: () async {
              final image = await controller.onCropImage();
              if (image != null) {
                setState(() {
                  imgFile = image;
                });
              }
            },
          ),
        ],
      );
    } else {
      print('some text');
    }
  }*/

  Widget displayImage() {
    if (imgFile == null) {
      return const Text("No Image Selected!");
    } else {
      return Image.file(
        imgFile!,
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
            ElevatedButton(
              onPressed: () {
                showOptionsDialog(context);
              },
              child: const Text("Select Image"),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
