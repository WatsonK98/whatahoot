import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'whata_caption_vote.dart';
import 'whata_caption_win.dart';

///Created By Nathanael Perez

///Caption page starting point
class WhataCaptionCaptionPage extends StatefulWidget {
  const WhataCaptionCaptionPage({super.key});

  ///initialize the state
  @override
  State<WhataCaptionCaptionPage> createState() => _WhataCaptionCaptionPageState();
}

///Page state
class _WhataCaptionCaptionPageState extends State<WhataCaptionCaptionPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _textEditingController = TextEditingController();
  late String? _imageUrl;
  late String? _imageId;

  ///Loads the image from cloud storage
  Future<void> _loadImage() async {
    SharedPreferences prefs = await _prefs;
    String? serverId = prefs.getString('joinCode');
    final storageRef = FirebaseStorage.instance.ref().child('$serverId');

    try {
      final ListResult result = await storageRef.listAll();
      if (result.items.isNotEmpty) {
        //Use the round to get the appropriate image
        int round = prefs.getInt('round') ?? 0;
        if (round < result.items.length) {
          print(result.items);
          final Reference firstImageRef = result.items[round];
          _imageUrl = await firstImageRef.getDownloadURL();
          _imageId = firstImageRef.name;
          prefs.setString('imageId', firstImageRef.name);
          setState(() {});
        } else {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const WhataCaptionWinPage()));
        }
      } else {
        print("No images found in the 'images' directory.");
      }
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  ///Sends the caption with reference data to the database
  Future<void> _setCaption() async {
    final SharedPreferences prefs = await _prefs;
    final String? serverId = prefs.getString('serverId');
    final String? playerId = prefs.getString('playerId');
    DatabaseReference captionRef = FirebaseDatabase.instance.ref().child('$serverId/images/$_imageId/${_textEditingController.text}');
    captionRef.set({
      'uid': playerId
    });
  }

  ///Initialize the state
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  ///Dispose of controllers
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Caption!"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            Center(
              child: _imageUrl != null
                  ? Image.network(
                _imageUrl!,
                width: 300,
                height: 300,
                fit: BoxFit.scaleDown,
              )
                  : const CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Caption',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_textEditingController.text.isNotEmpty){
                  _setCaption().then((_) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WhataCaptionVotePage()));
                  });
                }
              },
              child: const Text('Let\'s Go!'),
            ),
          ],
        ),
      ),
    );
  }
}