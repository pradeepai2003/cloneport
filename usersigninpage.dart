import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cloneport/userlogin.dart';
import 'package:e_cloneport/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}
class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool agreedToTerms = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _moblienumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController =
  TextEditingController();
  String? gender;
  bool showPassword = false; // To toggle password visibility
  Future<void> addUserDetails(String username, String mobilenumber, String
  email) async {
    await FirebaseFirestore.instance.collection("Users").doc(email).set({
      'username': username,
      'email': email,
      'mobilenumber': mobilenumber,
    });
  }
  Future<void> _signUpWithEmailPassword() async {
    try {
      final UserCredential userCredential = await
      _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await addUserDetails(
        _usernameController.text.trim(),
        _moblienumberController.text.trim(),
        _emailController.text.trim(),
      );
      // Navigate to the main page after successful signup
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => mainpage()),
      );
    } catch (e) {
      print("Failed to sign up with email/password: $e");
      // Handle signup failure, such as displaying an error message to the user
    }
  }
  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await
      _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential = await
        _auth.signInWithCredential(credential);
        // Navigate to the main page after successful signup
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => mainpage()),
        );
      }
    } catch (e) {
      print("Failed to sign in with Google: $e");
      // Handle signin failure, such as displaying an error message to the user
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        body: Stack(
        children: [
        // Background with transparency
        Container(
        decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('images/backlogin.jpg'), // Replace with your
    background image
    fit: BoxFit.cover,
    ),
    ),
    child: Opacity(
    opacity: 0.5, // Set the desired transparency value
    child: Container(
    color: Colors.black, // Set the background color
    ),
    ),
    ),
    SingleChildScrollView(
    child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    height: MediaQuery.of(context).size.height - 50,
    width: double.infinity,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
    Column(
    children: <Widget>[
    const SizedBox(height: 30.0),
    const Text(
    "Sign up",
    style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white),
    ),
    ],
    ),
    Card(
    color: Colors.white.withOpacity(0.5),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    children: <Widget>[
    TextField(
    controller: _usernameController,
    decoration: InputDecoration(
    hintText: "Username",
    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
    prefixIcon: Icon(Icons.person),
    border: InputBorder.none,
    ),
    ),
    SizedBox(height: 10),
    TextField(
    controller: _moblienumberController,
    decoration: InputDecoration(
    hintText: "Mobilenumber",
    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
    prefixIcon: Icon(Icons.numbers),
    border: InputBorder.none,
    ),
    ),
    SizedBox(height: 10),
    TextField(
    controller: _emailController,
    decoration: InputDecoration(
    hintText: "Email",
    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
    prefixIcon: Icon(Icons.email),
    border: InputBorder.none,
    ),
    ),
    SizedBox(height: 10),
    Row(
    children: <Widget>[
    Text(
    "Gender: ",
    style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    Radio<String>(
    value: "Male",
    groupValue: gender,
    onChanged: (value) {
    setState(() {
    gender = value;
    });
    },
    ),
    Text(
    "Male",
    style: TextStyle(color: Colors.white),
    ),
    Radio<String>(
    value: "Female",
    groupValue: gender,
    onChanged: (value) {
    setState(() {
    gender = value;
    });
    },
    ),
    Text(
    "Female",
    style: TextStyle(color: Colors.white),
    ),
    ],
    ),
    SizedBox(height: 10),
    TextField(
    controller: _passwordController,
    decoration: InputDecoration(
    hintText: "Password",
    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
    prefixIcon: Icon(Icons.password),
    suffixIcon: InkWell(
    onTap: () {
    setState(() {
    showPassword = !showPassword;
    });
    },
    child: Icon(
    showPassword ? Icons.visibility : Icons.visibility_off,
    color: Colors.white,
    ),
    ),
    border: InputBorder.none,
    ),
    obscureText: !showPassword,
    ),
    SizedBox(height: 10),
    TextField(
    controller: _confirmPasswordController,
    decoration: InputDecoration(
    hintText: "Confirm Password",
    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
    prefixIcon: Icon(Icons.password),
    border: InputBorder.none,
    ),
    obscureText: true,
    ),
    ],
    ),
    ),
    ),
    Row(
    children: <Widget>[
    Checkbox(
    value: agreedToTerms,
    onChanged: (value) {
    setState(() {
    agreedToTerms = value!;
    });
    },
    ),
    Text(
    'I agree to the terms and conditions',
    style: TextStyle(color: Colors.white),
    ),
    ],
    ),
    Container(
    padding: EdgeInsets.only(top: 3, left: 3),
    child: ElevatedButton(
    onPressed: agreedToTerms ? _signUpWithEmailPassword :
    null,
    child: Text(
    "Sign up",
    style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    style: ElevatedButton.styleFrom(
    shape: StadiumBorder(),
    padding: EdgeInsets.symmetric(vertical: 16),
    backgroundColor: Colors.purple,
    ),
    ),
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Text(
    "Already have an account?",
    style: TextStyle(color: Colors.white),
    ),
    TextButton(
    onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>LoginPage ()),
    );
    },
      child: Text("Login", style: TextStyle(color: Colors.purple)),
    )
    ],
    )
    ],
    ),
    ),
    ),
        ],
        ),
        ),
    );
  }
