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
  late Future<String?> _joinCode;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  Future<void> _createJoinCode() async {
    final SharedPreferences prefs = await _prefs;
    final String joinCode = getRandomString(5);

    setState(() {
      prefs.setString("userName", _textFieldController.text);
      _joinCode = prefs.setString('joinCode', joinCode!).then((bool success) {
        return joinCode;
      });
    });
  }

  @override
  void initState() {
    super.initState();
      _joinCode = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('join_code');
    });
  }

  final Random _rnd = Random();
  final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _createJoinCode().then((_) {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const QRJoin()));
                  });
                },
                child: const Text("Hooty Hoot!")),
            ElevatedButton(onPressed: () {}, child: const Text("Coming Soon!")),
            ElevatedButton(onPressed: () {}, child: const Text("Coming Soon!")),
          ],
        ),
      ),
    );
  }
}