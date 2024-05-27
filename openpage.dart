import 'package:e_cloneport/userlogin.dart';
import 'package:flutter/material.dart';
import 'adminloginpage.dart';
class SnapCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        appBar: AppBar(
          title: Text("CLONE PORT"),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.blue,
        ),
          body: Stack(
              children: [
          // Background image with transparency
          Container(
          decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/2d.png'), // Replace with your
          background image path
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Adjust the opacity as
            needed
            BlendMode.dstATop,
          ),
        ),
    ),
    ),
    Center(
    child: Container(
    height: 300.0,
    child: ListView(
    scrollDirection: Axis.horizontal,
    children: <Widget>[
    SizedBox(width: 100.0),
    Center(
    child: Container(
    width: 200.0,
    color: Colors.red,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    CircleAvatar(
    radius: 70,
    backgroundImage: AssetImage('images/profile.jpg'),
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    );
    },
    child: Text('User Login'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
    ),
    ),
    ],
    ),
    ),
    ),
    SizedBox(width: 80),
    Center(
    child: Container(
    width: 200.0,
    color: Colors.blue,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage('images/in1.png'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
            );
          },
          child: Text('Admin Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
              ],
          ),
        ),
    );

