import 'dart:convert';
import 'dart:io';
import 'package:akpa/model/editprofile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:akpa/service/profile_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class EditProfilePicture extends StatefulWidget {
  final Function(String) onImageUpdated;

  const EditProfilePicture({required this.onImageUpdated, Key? key})
      : super(key: key);

  @override
  _EditProfilePictureState createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  File? image;
  final ProfileService profileService = ProfileService();

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  // Resize the image  according to the required dimensions
  Future<File> resizeImage(File originalImage) async {
    final imageBytes = await originalImage.readAsBytes();
    final result = await FlutterImageCompress.compressWithList(
      imageBytes,
      minWidth: 400,
      minHeight: 400,
      quality: 80,
    );

    final resizedImage = File(originalImage.path)..writeAsBytesSync(result);
    return resizedImage;
  }

  Future<void> uploadProfilePicture() async {
    if (image != null) {
      try {
        File resizedImage = await resizeImage(image!);

        /// Send the resized image to the ProfileService for uploading
        EditImageResponse response =
            await profileService.updateProfilePicture(resizedImage);

        if (response.status) {
          String newImageUrl =
              'https://akpa.in/path/to/images/${response.imageFileName}';
          widget.onImageUpdated(newImageUrl); // Update the profile picture URL
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.message)));
          print('Profile updated: ${response.message}');
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.message)));
          print('Error: ${response.message}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading profile picture')));
        print('Error uploading image: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image first')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image == null
                ? const Text('No image selected.')
                : Image.file(image!, height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadProfilePicture,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
