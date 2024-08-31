import 'package:flutter/material.dart';

class AddMovies extends StatefulWidget {
  const AddMovies({super.key});

  @override
  State<AddMovies> createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Movies',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Expanded(
          child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      )),
    );
  }
}
