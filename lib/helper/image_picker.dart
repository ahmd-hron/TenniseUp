import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;

class Picker {
  static File? image;
  // ImagePicker _imagePicker = ImagePicker();
  static Future<File?> showImagePickDialoge(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () async {
              var f = await _pickGallaryImage();
              return Navigator.of(context).pop(f);
              // _pickGallaryImage();
            },
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                'pick from gallary',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: () async {
              var f = await _takeImage();
              return Navigator.of(context).pop(f);
            },
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                'take image',
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  static Future<File?> _pickGallaryImage() async {
    final xImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // imageQuality: 80,
        maxHeight: 200,
        maxWidth: 200);
    if (xImage == null) return null;
    File newImage = File(xImage.path);
    return newImage;
  }

  static Future<File?> _takeImage() async {
    final xImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        // imageQuality: 80,
        maxHeight: 200,
        maxWidth: 200);
    if (xImage == null) return null;
    File newImage = File(xImage.path);
    return newImage;
  }

  static Future<String?> saveImage(File? image, String imageName) async {
    if (image == null) return null;
    Directory appDir = await syspath.getApplicationDocumentsDirectory();
    final appDirPath = appDir.path;
    String savedLocation = '$appDirPath/$imageName.jbg';
    image.copy(savedLocation);
    return savedLocation;
  }

  static Future updateImage(File? newImage, String oldImagePath) async {
    if (newImage == null) return;
    File oldFile = File(oldImagePath);
    bool exists = await oldFile.exists();
    if (exists) await oldFile.delete();
    return newImage.copy(oldImagePath);
  }
}
