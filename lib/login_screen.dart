import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_layout/splash_screen.dart';
import 'app_drawer.dart'; // Import the modified AppDrawer class
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User found for that email");
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFAE9), // Set the background color here
      child: Scaffold(
        body: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your asset path
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
                SizedBox(height: 16.0),
                Text(
                  "PorkSafe",
                  style: GoogleFonts.poppins(
                    color: Color(0xFFEC615A),
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Login to Your App",
                  style: GoogleFonts.poppins(
                    color: Color(0xFFEC615A),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 44.0,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "User Email",
                    prefixIcon: Icon(Icons.mail, color: Color(0xFFEC615A)),
                  ),
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "User Password",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFEC615A)),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  "Don't Remember your Password?",
                  style: GoogleFonts.poppins(
                    color: Color(0xFF5347D9),
                  ),
                ),
                const SizedBox(
                  height: 88.0,
                ),
                Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF5347D9),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    onPressed: () async {
                      User? user = await loginUsingEmailPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                      );
                      print(user);
                      if (user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
