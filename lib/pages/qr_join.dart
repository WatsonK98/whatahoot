import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'whatacaption/whata_caption_upload.dart';

///Created by Alexandder Watson

///QR create game starting point
class QRJoinPage extends StatefulWidget {
  const QRJoinPage({super.key});

  ///Intialize the page state
  @override
  State<QRJoinPage> createState() => _QRJoinPageState();
}

///QR page state
class _QRJoinPageState extends State<QRJoinPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _joinCode;

  ///Initialize the data necessary, such as logging in the host, setting the current round
  Future<void> _initializeData() async {
    SharedPreferences prefs = await _prefs;
    FirebaseAuth.instance.signInAnonymously();

    String? playerId = FirebaseAuth.instance.currentUser?.uid;
    String? joinCode = await _joinCode;
    await prefs.setString('joinCode', joinCode);
    await prefs.setString('playerId', playerId!);
    String? serverId = 'servers/$joinCode';
    await prefs.setString('serverId', serverId);
    String? userName = prefs.getString('nickname');

    if (userName != null) {
      DatabaseReference playerRef = FirebaseDatabase.instance.ref().child('$serverId/players/$playerId');
      playerRef.set({
        'name': userName,
        'votes': 0
      });
    }
  }

  ///Initialize state loads the appropriate data
  @override
  void initState() {
    super.initState();

    _joinCode = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('joinCode') ?? '';
    });

    _joinCode.then((_) {
      _initializeData();
    });
  }

  ///Page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create Game"),
      ),
      body: Center(
        //Future builder waits for join code
        child: FutureBuilder<String?>(
          future: _joinCode,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                //show a circular progress indicator while waiting
                return const CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //QR code image for joining players
                      QrImageView(
                        data: "${snapshot.data}",
                        version: QrVersions.auto,
                        size: 220,
                      ),
                      const SizedBox(height: 16),
                      //Show the join code if joining player's camer is not working
                      Text("${snapshot.data}", style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                      //Button moves to the game
                      ElevatedButton(
                        onPressed: () {
                          //Update with switch/case statements when other game modes are implemented
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => const WhataCaptionUploadPage()));
                        },
                        child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
