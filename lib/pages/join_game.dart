import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class JoinGamePage extends StatefulWidget {
  const JoinGamePage({super.key});

  @override
  State<JoinGamePage> createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  final TextEditingController _joinCodeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _setJoinCode() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('joinCode', _joinCodeController.text!);
      prefs.setString('clientName', _nicknameController.text!);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Nickname',
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
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child:
                    ElevatedButton(
                        onPressed: () {
                          _setJoinCode().then((_) {

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
    );
  }
}