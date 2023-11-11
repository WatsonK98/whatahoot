import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'whata_caption_caption.dart';
import 'dart:io';

///Whatacaption upload page starting point
class WhataCaptionUploadPage extends StatefulWidget{
  const WhataCaptionUploadPage({super.key});

  ///Initialize the page state
  @override
  State<WhataCaptionUploadPage> createState() => _WhataCaptionUploadPageState();
}

///Upload page state
class _WhataCaptionUploadPageState extends State<WhataCaptionUploadPage>{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final storageRef = FirebaseStorage.instance.ref();
  static File? _imageFile;
  bool _imageUploaded = false;

  ///sends the image file to cloud storage
  Future<void> _findImageFile() async {
    SharedPreferences prefs = await _prefs;

    String? serverId = prefs.getString('joinCode');
    String? playerId = prefs.getString('playerId');

    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    setState(() {
      _imageFile = File(image.path);
    });

    final imageRef = storageRef.child("$serverId/$playerId");
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

  ///Page widget
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("WhataCaption!"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image file container
            const SizedBox(height: 10),
            Center(
              child: _imageFile != null
                      ? Image.memory(
                    _imageFile!.readAsBytesSync(),
                    scale: .5,
                    fit: BoxFit.cover,
                  )
                  : Container(height: 300),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //upload button sends the image to the cloud
                ElevatedButton.icon(
                    onPressed: () {
                      _findImageFile().then((_) => _imageUploaded == true);
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Upload')
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    //
                    onPressed: () {
                      //Only move on if an image was uploaded
                      if (_imageUploaded) {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => const WhataCaptionCaptionPage()));
                      }
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