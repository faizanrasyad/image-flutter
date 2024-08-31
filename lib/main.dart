import 'package:flutter/material.dart';
import 'package:image_flutter/pages/add_movies.dart';
import 'package:image_flutter/pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: "Image Flutter",
    theme: ThemeData(primarySwatch: Colors.green),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/add': (context) => AddMovies(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
