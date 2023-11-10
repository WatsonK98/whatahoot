import 'package:flutter/material.dart';
import 'package:whatahoot/pages/qr_join.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _textFieldController = TextEditingController();

  final Random _rnd = Random();
  final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> _createJoinCode() async {
    final SharedPreferences prefs = await _prefs;
    final String joinCode = getRandomString(5);

    prefs.setString('nickName', _textFieldController.text);
    prefs.setString('joinCode', joinCode);
    prefs.setInt('round', 1);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter A Nickname',
                ),
                maxLength: 8,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  _createJoinCode().then((_) {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const QRJoinPage()));
                  });
                },
                child: const Text("WhataCaption!")
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Coming Soon!")),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Coming Soon!")),
          ],
        ),
      ),
    );
  }
}