import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'openpage.dart';
class welcomepage extends StatefulWidget {
  const welcomepage({super.key});
  @override
  State<welcomepage> createState() => _welcomepageState();
}
class _welcomepageState extends State<welcomepage> {
  @override
  void initState() {
    var state = super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context as BuildContext).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SnapCarousel(),
          ),
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 51, 75),
      ),
      backgroundColor: const Color.fromARGB(255, 3, 51, 75),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            CircleAvatar(
              minRadius: 75,
              maxRadius: 75, // foregroundImage: AssetImage("2.jpg"),
              backgroundImage: AssetImage("images/Clone port.png"),
              backgroundColor: Colors.grey,

              // Replace with your image asset
            ),
          ],
        ),
      ),
    );
  }
}