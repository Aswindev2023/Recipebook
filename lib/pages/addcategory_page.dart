import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  PlatformFile? _imageFile;

Future<void>_pickImage()async{
try {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
   if (result == null) {
     return;
   }

      setState(() {
        _imageFile = result.files.first;
      });
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),);
}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Add Category',style: TextStyle(fontSize: 30,fontWeight:FontWeight.bold,color: Colors.black),),),
        body:SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: ,
            )
          ],
        ),)
    );
  }
}