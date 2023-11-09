import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'whata_caption_caption.dart';
import 'dart:io';

class WhataCaptionUploadPage extends StatefulWidget{
  const WhataCaptionUploadPage({super.key});

  @override
  State<WhataCaptionUploadPage> createState() => _WhataCaptionUploadPageState();
}

class _WhataCaptionUploadPageState extends State<WhataCaptionUploadPage>{
  final TextEditingController _textEditingController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final storageRef = FirebaseStorage.instance.ref();
  static File? _imageFile;

  Future<void> _findImageFile() async {
    final SharedPreferences prefs = await _prefs;
    final String? playerId = prefs.getString('playerId');
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      _imageFile = File(image.path);
    });
    final imageRef = storageRef.child("images/$playerId");
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
            _imageFile != null
              ? Image.memory(
                _imageFile!.readAsBytesSync(),
              width: 350,
              height: 350,
              fit: BoxFit.cover,
              )
              : Container(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () {
                      _findImageFile().then((_) => null);
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Upload')
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const WhataCaptionCaptionPage()));
                  },
                  child: const Text('Continue')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}