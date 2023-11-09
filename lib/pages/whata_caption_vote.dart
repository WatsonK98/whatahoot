import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'whata_caption_upload.dart';

class WhataCaptionVotePage extends StatefulWidget {
  const WhataCaptionVotePage({super.key});

  @override
  State<WhataCaptionVotePage> createState() => _WhataCaptionVotePageState();
}

class _WhataCaptionVotePageState extends State<WhataCaptionVotePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String? _imageUrl;

  Future<void> _loadImage() async {
    final storageRef = FirebaseStorage.instance.ref().child('images');
    final SharedPreferences prefs = await _prefs;

    try {
      final ListResult result = await storageRef.listAll();
      if (result.items.isNotEmpty) {
        final Reference firstImageRef = result.items.first;
        _imageUrl = await firstImageRef.getDownloadURL();
        setState(() {});
      } else {
        print("No images found in the 'images' directory.");
        int? currentRound = prefs.getInt('round');
        if (currentRound == Null) {
          prefs.setInt('round', 1);
          //go to upload
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const WhataCaptionUploadPage()));
        } else if (currentRound! == 1) {
          prefs.setInt('round', ++currentRound);
          //go to upload
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const WhataCaptionUploadPage()));
        } else {
          // go to win page
        }
      }
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Vote!"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            Center(
              child: _imageUrl != null
                  ? Image.network(
                _imageUrl!,
                cacheHeight: 350,
                cacheWidth: 350,
              )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      );
  }
}