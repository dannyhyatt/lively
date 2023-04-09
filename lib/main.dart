import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as FirebaseUI;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lively/groups_list_page.dart';
import 'package:lively/profile_page.dart';
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
        primaryColor: const Color(0xffff471A),
        buttonTheme: ButtonThemeData(buttonColor: Color(0xffff471A)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffff471A)))),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Color(0xffff471A), backgroundColor: Colors.white),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle:
              GoogleFonts.kanit(color: Color(0xffff471A), fontSize: 24.0),
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
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.phoneNumber)
            .get()
            .then((snapshot) {
          if (snapshot.exists)
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GroupListPage(
                    displayName: snapshot.data()?['name'],
                    bio: snapshot.data()?['bio'],
                    imageUrl: snapshot.data()?['imageUrl'])));
          else
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ProfilePage()));
        });
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
                  fontSize: 36, color: const Color(0xffff471A)),
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
