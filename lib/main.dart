import 'package:firebase_ui_auth/firebase_ui_auth.dart' as FirebaseUI;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lively',
      theme: ThemeData(
        primarySwatch: Colors.red,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Color(0xffff471A), backgroundColor: Colors.white),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(color: Color(0xffff471A)),
        ),
      ),
      darkTheme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;

  _MyHomePageState() {
    init();
  }

  void init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setState(() {
      loaded = true;
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) return Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(),
            Text(
              'lively',
              style: GoogleFonts.kanit(
                  fontSize: 36,
                  color: Theme.of(context).appBarTheme.titleTextStyle!.color),
            ),
            ElevatedButton(
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FirebaseUI.PhoneInputScreen()))
                    },
                child: Text(
                  'Sign in with Phone',
                  style: TextStyle(fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
