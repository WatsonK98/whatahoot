import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WhataCaptionCaptionPage extends StatefulWidget {
  const WhataCaptionCaptionPage({super.key});

  @override
  State<WhataCaptionCaptionPage> createState() => _WhataCaptionCaptionPageState();
}

class _WhataCaptionCaptionPageState extends State<WhataCaptionCaptionPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _textEditingController = TextEditingController();
  late String? _serverId;
  late String? _playerId;
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
        title: const Text("Time to Vote!"),
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

              },
              child: const Text('Let\'s Go!')
            ),
          ],
        ),
      ),
    );
  }
}