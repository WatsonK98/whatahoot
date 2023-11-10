import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'whata_caption_upload.dart';

class QRJoinPage extends StatefulWidget {
  const QRJoinPage({super.key});

  @override
  State<QRJoinPage> createState() => _QRJoinPageState();
}

class _QRJoinPageState extends State<QRJoinPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String?> _joinCode;
  late Future<String?> _userName;

  @override
  void initState() {

    super.initState();

    FirebaseAuth.instance.signInAnonymously();
    String? playerId = FirebaseAuth.instance.currentUser?.uid;
    String? serverId;

    _joinCode = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('joinCode');
    });

    _joinCode.then((joinCode) {
      if (joinCode != null) {
        serverId = 'servers/$joinCode';
      }
    });

    _userName = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('hostName');
    });

    _userName.then((username) {
      if (username != null) {
        DatabaseReference playerRef = FirebaseDatabase.instance.ref().child('$serverId/players/$playerId');
        playerRef.set({
          'name': username,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create Game"),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _joinCode,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      QrImageView(
                        data: "${snapshot.data}",
                        version: QrVersions.auto,
                        size: 220,
                      ),
                      Text("${snapshot.data}", style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
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
