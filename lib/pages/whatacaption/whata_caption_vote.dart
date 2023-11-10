import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhataCaptionVotePage extends StatefulWidget {
  const WhataCaptionVotePage({super.key});

  @override
  State<WhataCaptionVotePage> createState() => _WhataCaptionVotePageState();
}

class _WhataCaptionVotePageState extends State<WhataCaptionVotePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> captions = [];
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
                  : const CircularProgressIndicator()
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}