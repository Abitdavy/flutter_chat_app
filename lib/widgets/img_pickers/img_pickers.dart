import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImgPicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFunc;

  ImgPicker(this.imagePickFunc);

  @override
  State<ImgPicker> createState() => _ImgPickerState();
}

class _ImgPickerState extends State<ImgPicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFunc(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('add image'),
        ),
      ],
    );
  }
}
