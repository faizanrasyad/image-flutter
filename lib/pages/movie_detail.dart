import 'package:flutter/cupertino.dart';
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
    double height = MediaQuery.of(context).size.height;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      child: ClipRRect(
                        child: Image.network(
                          movie.image,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    movie.name,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.movie,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        movie.production,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
