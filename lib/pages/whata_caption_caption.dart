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
  final storageRef = FirebaseStorage.instance.ref();
  late String? _serverId;
  late String? _playerId;
  late String? _imageId;
  late String? _imageUrl;

  Future<void> _loadImage() async {
    final SharedPreferences prefs = await _prefs;
    _serverId = prefs.getString('serverId');
    _playerId = prefs.getString('playerId');
    _imageId = prefs.getString('imageId');

    if(_serverId != null && _playerId != null) {
      final imageRef = storageRef.child(_imageId!);

      try{
        _imageUrl = await imageRef.getDownloadURL();
      } catch (e) {
        print("Error loading");
      }

      setState(() {});
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