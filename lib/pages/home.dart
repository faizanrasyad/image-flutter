import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_flutter/networking/client/dio.dart';
import 'package:image_flutter/networking/models/movies_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Movies> movies = [];

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get('${DioClient().baseUrl}/movies');
      List<dynamic> jsonData = response.data;

      setState(() {
        movies = jsonData.map((e) => Movies.fromJson(e)).toList();
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
      return e.response!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    getMovies();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Image Flutter',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Image.asset(
          'assets/note_stack_add.png',
          width: 40,
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'List Movies',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: movies!.length < 1
                    ? const Center(
                        child: Text("There is no movie..."),
                      )
                    : ListView.builder(
                        itemCount: movies!.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        movies![index].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movies![index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.movie,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(movies![index].production),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })))
          ],
        ),
      )),
    );
  }
}
