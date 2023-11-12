import 'package:flutter/material.dart';
import 'package:whatahoot/pages/qr_join.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

///Created by Jesus T.D.

///Stateful widget for create game ensures user input
class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  //Initialize the state
  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

///Page state for create game
class _CreateGamePageState extends State<CreateGamePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _textFieldController = TextEditingController();

  //Random alphanumeric generator in lambda
  final Random _rnd = Random();
  final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  ///Create join code method gets the user nickname and generated join code.
  ///Saves the join code, and initializes the round to 0 to help with
  ///indexing of online resources
  Future<void> _createJoinCode() async {
    final SharedPreferences prefs = await _prefs;
    final String joinCode = getRandomString(5);

    await prefs.setString('nickName', _textFieldController.text);
    await prefs.setString('joinCode', joinCode);
    await prefs.setInt('round', 0);
  }

  ///Dispose clears the controller and any other listeners except for
  ///shared preferences
  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  ///Main create game page widget
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
                  //Ensure that it locks in the and transitions page information
                  _createJoinCode().then((_) {
                    if(_textFieldController.text.isNotEmpty) {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => const QRJoinPage()));
                    }
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