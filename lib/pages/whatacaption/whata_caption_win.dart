import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WhataCaptionWinPage extends StatefulWidget {
  const WhataCaptionWinPage({super.key});

  @override
  State<WhataCaptionWinPage> createState() => _WhataCaptionWinPageState();
}

class _WhataCaptionWinPageState extends State<WhataCaptionWinPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Winner!"),
      ), body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

        ],
      ),
    );
  }
}