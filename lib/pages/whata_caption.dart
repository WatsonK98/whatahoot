import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class WhataCaptionPage extends StatefulWidget{
  const WhataCaptionPage({super.key});

  @override
  State<WhataCaptionPage> createState() => _WhataCaptionPageState();
}

class _WhataCaptionPageState extends State<WhataCaptionPage>{
  final TextEditingController _textEditingController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final storageRef = FirebaseStorage.instance.ref();
  int _votes = 0;
  static File? _imageFile;

  Future<void> _findImageFile() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      _imageFile = File(image.path);
    });
    final imageRef = storageRef.child("images/${DateTime.now().millisecondsSinceEpoch}");
    try {
      UploadTask uploadTask = imageRef.putFile(_imageFile!);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });
      await uploadTask.whenComplete(() {
        print('Upload complete');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("WhataCaption!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Score: $_votes', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                _findImageFile().then((_) => null);
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Upload')
            ),
          ],
        ),
      ),
    );
  }
}