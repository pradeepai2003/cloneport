import 'package:e_cloneport/drawer.dart';
import 'package:e_cloneport/process1file.dart';
import 'package:e_cloneport/userlogin.dart';
import 'package:flutter/material.dart';
import 'list of shop.dart';
class mainpage extends StatefulWidget {
  const mainpage({Key? key}) : super(key: key);
  @override
  State<mainpage> createState() => _mainpageState();
}
class _mainpageState extends State<mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        actions: [
        IconButton(
        icon: Icon(Icons.logout),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    );
    },
        ),
        ],
          title: Text("CLONE PORT"),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      drawer: homeicon(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search for the Location....",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the next page when the FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShopList()),
          );
        },
        child: Icon(Icons.recent_actors),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }
}
