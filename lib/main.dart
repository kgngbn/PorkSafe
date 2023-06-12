import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFEC615A), // Change the primary color to red
        appBarTheme: AppBarTheme(
          elevation: 10,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
    );
  }
}
