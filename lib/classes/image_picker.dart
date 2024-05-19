import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerAndDisplay extends StatefulWidget {
  final void Function(List<Uint8List> bytesList) onImagesSelected;
  final List<Uint8List> initialImageBytesList;

  const ImagePickerAndDisplay({
    Key? key,
    required this.onImagesSelected,
    required this.initialImageBytesList,
  }) : super(key: key);

  @override
  State<ImagePickerAndDisplay> createState() => _ImagePickerAndDisplayState();
}

class _ImagePickerAndDisplayState extends State<ImagePickerAndDisplay> {
  final ImagePicker _imagePicker = ImagePicker();
  List<Uint8List> _imageBytesList = [];

  @override
  void initState() {
    super.initState();
    _imageBytesList = List.from(widget.initialImageBytesList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Pick Images'),
        ),
        const SizedBox(height: 20),
        _imageBytesList.isEmpty
            ? const Text('No images selected')
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageBytesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        _imageBytesList[index],
                        width: 400,
                        fit: BoxFit.contain,
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
    if (pickedImages.isNotEmpty) {
      List<Uint8List> bytesList = [];
      for (var pickedImage in pickedImages) {
        final bytes = await pickedImage.readAsBytes();
        bytesList.add(bytes);
      }
      setState(() {
        _imageBytesList = bytesList;
      });
      widget.onImagesSelected(_imageBytesList);
    }
  }
}
