import 'dart:async';
import 'dart:convert';

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

  ///Load Image from the net storage container
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

  ///Load captions from the database
  Future<void> _loadCaptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serverId = prefs.getString('serverId');
    DatabaseReference captionsRef = FirebaseDatabase.instance.ref().child('$serverId/captions/');
    final snapshot = await captionsRef.get();
    if (snapshot.exists) {
      String data = snapshot.value.toString();

      // Remove the enclosing curly braces and split the string by commas
      List<String> pairs = data.substring(1, data.length - 1).split(', ');

      Map<String, String> parsedData = {};

      pairs.forEach((pair) {
        List<String> keyValue = pair.split(': {uid: ');
        String key = keyValue[0].trim();
        captions.add(key);
      });
    } else {
      print('No data available.');
    }
  }

  ///update the caption vote
  Future<void> _voteCaption(String caption) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serverId = prefs.getString('serverId');
    DatabaseReference captionsRef = FirebaseDatabase.instance.ref().child('$serverId/captions/$caption/uid');
    final snapshot = await captionsRef.get();
    if (snapshot.exists) {
      DatabaseReference votesRef = FirebaseDatabase.instance.ref().child('$serverId/players/${snapshot.value.toString()}/votes');
      final snapshot2 = await votesRef.get();
      if (snapshot2.exists) {
        int vote = int.parse(snapshot2.value.toString());
        vote++;
        votesRef.set(vote);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadCaptions();
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: captions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(captions[index]),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      _voteCaption(captions[index]);
                    },
                    child: const Text('Vote'),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}