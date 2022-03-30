import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor/crop_screen.dart';
import 'package:image_picker/image_picker.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ImagePicker _picker = ImagePicker();
  MemoryImage? imageToCrop;
  String? image;

  Widget displayImage() {
    if (imageToCrop == null) {
      return const Text("No Image Selected!");
    } else {
      return Image(image: imageToCrop!,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayImage(),
            ElevatedButton(
              child: const Text('Pick image'),
              onPressed: () async {
                final image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  final imageBytes = image.path;
                  openForResult(imageBytes);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future openForResult(image) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CropScreen(image)));
    setState(() {
      imageToCrop = result;
    });
  }
}
