import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (_, snapshot) {
          return MaterialApp(
            title: 'Material App',
            home: AudioServiceWidget(
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Material App Bar'),
                ),
                body: Center(
                  child: Container(
                    child: Text('Hello World'),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
