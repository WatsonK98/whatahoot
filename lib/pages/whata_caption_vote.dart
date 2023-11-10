import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WhataCaptionVotePage extends StatefulWidget {
  const WhataCaptionVotePage({super.key});

  @override
  State<WhataCaptionVotePage> createState() => _WhataCaptionVotePageState();
}

class _WhataCaptionVotePageState extends State<WhataCaptionVotePage> {
  late String? _imageUrl;

  Future<void> _loadImage() async {
    final storageRef = FirebaseStorage.instance.ref().child('images');

    try {
      final ListResult result = await storageRef.listAll();
      if (result.items.isNotEmpty) {
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
        title: const Text("Vote!"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageUrl != null
                ? Image.network(
              _imageUrl!,
              width: 200, // Set the width as needed
              height: 200, // Set the height as needed
            )
                : const Text("Image not available"),
            const SizedBox(height: 16),
          ],
        ),
      );
  }
}