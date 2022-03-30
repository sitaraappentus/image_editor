import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';

class CropScreen extends StatefulWidget {

  final String image;
  CropScreen(this.image);

  @override
  State<CropScreen> createState() => _CropScreenState();
}
class _CropScreenState extends State<CropScreen> {

  CustomImageCropController? controller;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop"),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
              cropPercentage: 1,
              cropController: controller!,
              shape: CustomCropShape.Square,
              image : FileImage(File(widget.image)),
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: controller!.reset),
              IconButton(icon: const Icon(Icons.zoom_in), onPressed: () => controller!.addTransition(CropImageData(scale: 1.33))),
              IconButton(icon: const Icon(Icons.zoom_out), onPressed: () => controller!.addTransition(CropImageData(scale: 0.75))),
              IconButton(icon: const Icon(Icons.rotate_left), onPressed: () => controller!.addTransition(CropImageData(angle: -pi / 4))),
              IconButton(icon: const Icon(Icons.rotate_right), onPressed: () => controller!.addTransition(CropImageData(angle: pi / 4))),
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: () async {
                  final imageBytes = await controller!.onCropImage();
                  if (imageBytes != null) {
                    Navigator.pop(context, imageBytes);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
