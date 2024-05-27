import 'package:e_cloneport/signinpage.dart';
import 'package:e_cloneport/userfrogetpassword%20page.dart';
import 'package:e_cloneport/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false; // Added variable to track password visibility
  void _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      // Navigate to the main page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => mainpage()),
      );
    } catch (e) {
      print("Failed to sign in with email/password: $e");
      // Handle login failure, such as displaying an error message to the user
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('images/backlogin.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
    Colors.black.withOpacity(0.5), BlendMode.darken),
    ),
    ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _header(),
                  Card(
                    color: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: _inputField(),
                    ),
                  ),
                  _forgotPassword(),
                  _signup(),
                ],
              ),
            ),
          ),
        ),
    );
  }
  Widget _header() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          "Enter the login infromation in the account",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
  Widget _inputField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        hintText: "Email Id",
        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white.withOpacity(0.3),
        filled: true,
        prefixIcon: Icon(Icons.person),
      ),
    ),
    const SizedBox(height: 10),
    TextField(
    controller: _passwordController,
    decoration: InputDecoration(
    hintText: "Password",
    hintStyle: TextStyle(fontSize: 14, color: Colors.white),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
    ),
    fillColor: Colors.white.withOpacity(0.3),
    filled: true,
    prefixIcon: Icon(Icons.lock),
    suffixIcon: IconButton(
    icon: Icon(
    _showPassword ? Icons.visibility : Icons.visibility_off,
    color: Colors.grey,
    ),
    onPressed: () {
    setState(() {
    _showPassword = !_showPassword;
    });
    },
    ),
    ),
    obscureText: !_showPassword, // Toggle password visibility
    ),
    const SizedBox(height: 20,),
    ElevatedButton(
    onPressed: _signInWithEmailAndPassword,
    style: ElevatedButton.styleFrom(
    shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(vertical: 20),
      backgroundColor: Colors.purple,
    ),
      child: const Text(
        "Login",
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    ),
        ],
    );
  }
  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      },
      child: const Text("Forgot password?", style: TextStyle(color:
      Colors.white)),
    );
  }
  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ", style: TextStyle(color:
        Colors.white)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }
