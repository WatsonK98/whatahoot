import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRJoin extends StatefulWidget {
  const QRJoin({super.key});

  @override
  State<QRJoin> createState() => _QRJoinState();
}

class _QRJoinState extends State<QRJoin> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String?> _joinCode;

  @override
  void initState() {
    super.initState();
    _joinCode = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('join_code');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create Game"),
      ), body: Center(
        child: FutureBuilder<String?>(
          future: _joinCode,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      QrImageView(
                        data: "${snapshot.data}",
                        version: QrVersions.auto,
                        size: 220,
                      ),
                      Text("${snapshot.data}", style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          //Go to the game state once everyone has joined
                          //Navigator.push(context,
                            //MaterialPageRoute(
                                //builder: (context) => ));
                        },

                        child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
