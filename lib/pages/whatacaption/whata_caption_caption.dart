import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'whata_caption_vote.dart';

class WhataCaptionCaptionPage extends StatefulWidget {
  const WhataCaptionCaptionPage({super.key});

  @override
  State<WhataCaptionCaptionPage> createState() => _WhataCaptionCaptionPageState();
}

class _WhataCaptionCaptionPageState extends State<WhataCaptionCaptionPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _textEditingController = TextEditingController();
  late String? _imageUrl;

  Future<void> _loadImage() async {
    SharedPreferences prefs = await _prefs;
    String? serverId = prefs.getString('joinCode');
    final storageRef = FirebaseStorage.instance.ref().child('$serverId');
    int? round = prefs.getInt('round');

    try {
      final ListResult result = await storageRef.listAll();
      if (result.items.isNotEmpty) {
        if (round! > 1) {
          result.items.first.delete();
        }
        final Reference firstImageRef = result.items.first;
        _imageUrl = await firstImageRef.getDownloadURL();
        setState(() {});
      } else {
        print("No images found in the 'images' directory.");
      }
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  Future<void> _setCaption() async {
    final SharedPreferences prefs = await _prefs;
    final String? serverId = prefs.getString('serverId');
    final String? playerId = prefs.getString('playerId');
    DatabaseReference captionRef = FirebaseDatabase.instance.ref().child('$serverId/captions/${_textEditingController.text}');
    captionRef.set({
      'uid': playerId
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
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
                scale: 0.5,
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
                _setCaption().then((_) {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => const WhataCaptionVotePage()));
                });
              },
              child: const Text('Let\'s Go!')
            ),
          ],
        ),
      ),
    );
  }
}