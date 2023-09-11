import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_layout/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final User? user; // Add the 'user' parameter here

  const LoginScreen({Key? key, this.user}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  static Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  static Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFAE9),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFEC615A),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
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
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16.0,
                      color: Color(0xFFEC615A),
                    ),
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
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16.0,
                      color: Color(0xFFEC615A),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFEC615A)),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Don't Remember your Password?",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF5347D9),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 88.0,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      RawMaterialButton(
                        fillColor: Color(0xFF5347D9),
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
                            Navigator.pushReplacement(
                              context,
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
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                            color: Color(0xFF5347D9),
                          ),
                        ),
                      ),
                    ],
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

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _acceptTerms = false; // Add this boolean variable

  static Future<User?> createAccountUsingEmailPassword({
    required String email,
    required String password,
    required String userName,
    required String location,
    required bool acceptTerms, // Add this parameter
    required BuildContext context,
  }) async {
    if (!acceptTerms) {
      // Check if terms and conditions are accepted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please accept the terms and conditions.'),
          backgroundColor: Colors.red,
        ),
      );
      return null; // Return null if terms are not accepted
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      if (user != null) {
        // Set additional user information
        // ...
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        backgroundColor: Color(0xFFEC615A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _newEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "New Email",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.0,
                  color: Color(0xFFEC615A),
                ),
                prefixIcon: Icon(Icons.mail, color: Color(0xFFEC615A)),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "New Password",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.0,
                  color: Color(0xFFEC615A),
                ),
                prefixIcon: Icon(Icons.lock, color: Color(0xFFEC615A)),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: "User Name",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.0,
                  color: Color(0xFFEC615A),
                ),
                prefixIcon: Icon(Icons.person, color: Color(0xFFEC615A)),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: "Location",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.0,
                  color: Color(0xFFEC615A),
                ),
                prefixIcon: Icon(Icons.location_on, color: Color(0xFFEC615A)),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
                Text(
                  "I accept the terms and conditions",
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Color(0xFFEC615A),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_acceptTerms) {
                  // Check if terms and conditions are accepted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please accept the terms and conditions.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                User? user = await createAccountUsingEmailPassword(
                  email: _newEmailController.text,
                  password: _newPasswordController.text,
                  userName: _userNameController.text,
                  location: _locationController.text,
                  acceptTerms: _acceptTerms, // Pass acceptTerms to the function
                  context: context,
                );
                print(user);
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5347D9),
                onPrimary: Colors.white,
              ),
              child: Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent. Please check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        backgroundColor: Color(0xFFEC615A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot your password?",
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEC615A),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Enter your email address below to receive a password reset link.",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: Color(0xFFEC615A),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.0,
                  color: Color(0xFFEC615A),
                ),
                prefixIcon: Icon(Icons.mail, color: Color(0xFFEC615A)),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  _resetPassword(email);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your email.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5347D9),
                onPrimary: Colors.white,
              ),
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
