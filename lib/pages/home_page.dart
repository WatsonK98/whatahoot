import 'package:flutter/material.dart';
import 'join_game.dart';
import 'create_game.dart';

///Created by Adrian Urquizo

///Homepage starting point
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  ///Initialize the homepage state
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

///Homepage state
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Join game button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const JoinGamePage(),
                  ),
                );
              },
              child: const Text("Join Game"),
            ),
            const SizedBox(height: 10),
            //Create game button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateGamePage(),
                  ),
                );
              },
              child: const Text("Create Game"),
            ),
          ],
        ),
      ),
    );
  }
}