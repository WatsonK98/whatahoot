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

  Future<void> _createJoinCode() async {
    final SharedPreferences prefs = await _prefs;
    final String joinCode = getRandomString(5);

    setState(() {
      _joinCode = prefs.setString('join_code', joinCode!).then((bool success) {
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