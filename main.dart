import 'package:e_cloneport/adminregistrationpage.dart';
import 'package:e_cloneport/welcomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: welcomepage(),
    debugShowCheckedModeBanner: false,
  ));
}
