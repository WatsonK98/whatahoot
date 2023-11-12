import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

///Created by Samuel Sanchez

class WhataCaptionWinPage extends StatefulWidget {
  const WhataCaptionWinPage({super.key});

  @override
  State<WhataCaptionWinPage> createState() => _WhataCaptionWinPageState();
}

class _WhataCaptionWinPageState extends State<WhataCaptionWinPage>{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final String _winner = "One Sec!";

  Future<void> _findWinner() async {
    SharedPreferences prefs = await _prefs;
    String? serverId = prefs.getString('serverId');

    DatabaseReference playerRef = FirebaseDatabase.instance.ref().child('$serverId/players');
    Future<DatabaseEvent> playerSnapshot = playerRef.orderByChild('votes').orderByValue().once();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Winner!"),
      ), body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_winner),
        ],
      ),
    );
  }
}