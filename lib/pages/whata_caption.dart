import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WhataCaptionPage extends StatefulWidget{
  const WhataCaptionPage({super.key});

  @override
  State<WhataCaptionPage> createState() => _WhataCaptionPageState();
}

class _WhataCaptionPageState extends State<WhataCaptionPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Join Game"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Score: '),
              ],
            ),
          ],
        ),
      ),
    );
  }
}