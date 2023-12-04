import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'whata_caption_caption.dart';

///Created by Gustavo Rubio

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
    SharedPreferences prefs = await _prefs;
    //Initialize search params
    String? serverId = prefs.getString('joinCode');
    final storageRef = FirebaseStorage.instance.ref().child('$serverId');

    try {
      //Attempt to get the first image
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
    SharedPreferences prefs = await _prefs;
    //Load search params
    String? serverId = prefs.getString('serverId');
    String? imageId = prefs.getString('imageId');
    //open a reference
    DatabaseReference captionsRef = FirebaseDatabase.instance.ref().child('$serverId/images/$imageId/');
    //create a snapshot
    final snapshot = await captionsRef.get();

    if (snapshot.exists) {
      //get the value of the snapshot
      final data = snapshot.value.toString();
      print(data);
      final dat = jsonEncode(snapshot.value);
      // Remove the enclosing curly braces and split the string by commas
      List<String> pairs = data.substring(1, data.length - 1).split(', ');

      //go through each pair
      for (var pair in pairs) {
        //split the pairs to get the key value
        List<String> keyValue = pair.split(': {uid: ');
        //trim the key
        String key = keyValue[0].trim();
        //add the key
        captions.add(key);
      }
    } else {
      print('No data available.');
    }
  }

  ///update the caption vote
  Future<void> _voteCaption(String caption) async {
    SharedPreferences prefs = await _prefs;
    //Get search param
    String? serverId = prefs.getString('serverId');
    //Make a reference to location in database
    DatabaseReference captionsRef = FirebaseDatabase.instance.ref().child('$serverId/captions/$caption/uid');
    final snapshot = await captionsRef.get();

    if (snapshot.exists) {
      //Get the vote UID
      String? playerId = snapshot.value.toString();
      print('player $playerId');
      DatabaseReference votesRef = FirebaseDatabase.instance.ref().child('$serverId/players/$playerId/votes');
      final snapshot2 = await votesRef.get();

      if (snapshot2.exists) {
        //Update vote count and round
        int vote = int.parse(snapshot2.value.toString());
        print('vote $vote');
        vote++;

        await votesRef.set({'votes': vote});

        int round = prefs.getInt('round') ?? 0;
        round++;
        await prefs.setInt('round', round);
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
                    width: 300,
                    height: 300,
                    fit: BoxFit.scaleDown,
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
                    onPressed: () {
                      _voteCaption(captions[index]).then((_) {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => const WhataCaptionCaptionPage()));
                      });
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