import 'package:flutter/material.dart';
import 'package:image_flutter/networking/models/movies_model.dart';

class MovieDetail extends StatefulWidget {
  final Movies movie;
  const MovieDetail({super.key, required this.movie});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    Movies movie = widget.movie;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Movie Detail',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Expanded(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Text("Movie Name: ${movie.name}"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
