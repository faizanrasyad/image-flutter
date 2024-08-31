import 'package:flutter/material.dart';
import 'package:image_flutter/pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: "Image Flutter",
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
