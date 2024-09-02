import 'package:flutter/material.dart';
import 'package:image_flutter/pages/add_movies.dart';
import 'package:image_flutter/pages/home.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(GlobalLoaderOverlay(
      child: MaterialApp(
    title: "Image Flutter",
    theme: ThemeData(primarySwatch: Colors.green),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/add': (context) => AddMovies(),
    },
    debugShowCheckedModeBanner: false,
  )));
}
