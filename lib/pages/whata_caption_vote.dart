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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Vote!"),
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
                cacheHeight: 350,
                cacheWidth: 350,
              )
                  : const CircularProgressIndicator(),
            ),
            
          ],
        ),
      ),
    );
  }
}