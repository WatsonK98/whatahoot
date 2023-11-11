import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'whatacaption/whata_caption_upload.dart';

class JoinGamePage extends StatefulWidget {
  const JoinGamePage({super.key});

  @override
  State<JoinGamePage> createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  final TextEditingController _joinCodeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

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
      prefs.setString('playerId', playerId!);
      prefs.setString('serverId', serverId);
      prefs.setString('joinCode', _joinCodeController.text);
      prefs.setInt('round', 0);
      return true;
    } else {
      return false;
    }
  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _joinCodeController.text = scanData.code!;
      });
      controller.stopCamera();
    });
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

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
              SizedBox(
                height: 300,
                width: 300,
                child: QRView(
                  key: _qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              const SizedBox(height: 16),
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
                      Expanded(child:
                        ElevatedButton(
                          onPressed: () {
                            _setJoinCode().then((bool success) {
                              if (success && _nicknameController.text.isNotEmpty) {
                                controller?.stopCamera();
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => const WhataCaptionUploadPage()));
                              } else {
                                _joinCodeController.clear();
                              }
                            });
                          },
                          child: const Text("Join"),
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