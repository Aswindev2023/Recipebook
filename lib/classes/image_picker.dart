// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerAndDisplay extends StatefulWidget {
  final void Function(List<String> urls) onImagesSelected;

  const ImagePickerAndDisplay({
    Key? key,
    required this.onImagesSelected,
  }) : super(key: key);

  @override
  State<ImagePickerAndDisplay> createState() => _ImagePickerAndDisplayState();
}

class _ImagePickerAndDisplayState extends State<ImagePickerAndDisplay> {
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Pick Images'),
        ),
        const SizedBox(height: 20),
        _imageUrls.isEmpty
            ? const Text('No images selected')
            : Container(
                height: 200, // Set a fixed height for the container
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 400,
                      child: Image.file(
                        File(_imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Future<void> _pickImages() async {
    List<XFile>? pickedImages = await _imagePicker.pickMultiImage();
    if (pickedImages != null) {
      List<String> imagePaths = [];
      for (var pickedImage in pickedImages) {
        // Read image file
        final File imageFile = File(pickedImage.path);
        final img.Image? image = img.decodeImage(await imageFile.readAsBytes());

        // Resize image
        final img.Image resizedImage =
            img.copyResize(image!, width: 800); // Adjust width as needed

        // Save resized image to temporary file
        final File resizedFile = File(
            '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await resizedFile.writeAsBytes(img.encodeJpg(resizedImage,
            quality: 85)); // Adjust quality if needed

        // Get path of resized image
        final String resizedImagePath = resizedFile.path;
        imagePaths.add(resizedImagePath);
      }
      setState(() {
        _imageUrls = List.from(_imageUrls)..addAll(imagePaths);
      });
      widget.onImagesSelected(_imageUrls);
    }
  }
}
