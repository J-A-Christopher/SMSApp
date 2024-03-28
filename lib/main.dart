import 'package:flutter/material.dart';
import 'package:sms/screens/home_page.dart';

///Entry point of our flutter application (The main method)
void main() {
  ///Method to run the widget SmsApp
  runApp(const SmsApp());
}

///StatelessWidget SmsApp 
class SmsApp extends StatelessWidget {
  const SmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    ///MaterialApp Widget with the home argument and debugBanner parameter set to false
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmsHomePage(),
    );
  }
}
