import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'whatacaption/whata_caption_upload.dart';

///Created by Francisco Vazquez

///Join game page starting point
class JoinGamePage extends StatefulWidget {
  const JoinGamePage({super.key});

  ///Initialize the state
  @override
  State<JoinGamePage> createState() => _JoinGamePageState();
}

///Join game page state
class _JoinGamePageState extends State<JoinGamePage> {
  final TextEditingController _joinCodeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  ///Sets the join code but also logs the player and puts them in the server
  Future<bool> _setJoinCode() async {
    final SharedPreferences prefs = await _prefs;
    await FirebaseAuth.instance.signInAnonymously();
    String? playerId = FirebaseAuth.instance.currentUser?.uid.toString();
    String serverId = 'servers/${_joinCodeController.text}';
    DatabaseReference serverRef = FirebaseDatabase.instance.ref().child(serverId);
    final snapshot = await serverRef.get();
    if (snapshot.exists) {
      DatabaseReference playerRef = FirebaseDatabase.instance.ref().child('$serverId/players/$playerId');
      playerRef.set({
        'name': _nicknameController.text,
        'votes': 0
      });

      //Save all of the credentialing for further usage
      await prefs.setString('playerId', playerId!);
      await prefs.setString('serverId', serverId);
      await prefs.setString('joinCode', _joinCodeController.text);
      //setting round to zero here allows client players to follow along
      await prefs.setInt('round', 0);

      return true;
    } else {
      return false;
    }
  }

  ///Method for capturing QR codes and updating the controller
  ///stops the camera after capture
  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _joinCodeController.text = scanData.code!;
      });
      controller.stopCamera();
    });
  }

  ///Disposes both controllers to free memory
  @override
  void dispose() {
    _joinCodeController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  ///Main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Join Game"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Container for QR view port
              SizedBox(
                height: 300,
                width: 300,
                child: QRView(
                  key: _qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              const SizedBox(height: 16),
              //Container for user nickname
              SizedBox(
                width: 300,
                height: 85,
                child: TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Nickname',
                  ),
                  maxLength: 8,
                ),
              ),
              //Container for Join Code textfield
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _joinCodeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Join Code',
                          ),
                          maxLength: 5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      //Container for the join button
                      Expanded(child:
                        ElevatedButton(
                          onPressed: () {
                            //When the joincode button is pressed ensures that nickname was entered and the nickname and join code are not the same
                            _setJoinCode().then((bool success) {
                              if (success && _nicknameController.text.isNotEmpty && _nicknameController.text != _joinCodeController.text) {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => const WhataCaptionUploadPage()));
                              } else {
                                _joinCodeController.clear();
                              }
                            });
                          },
                          child: const Text("Join!"),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
       ),
      ),
    );
  }
}