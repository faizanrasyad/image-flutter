import 'package:flutter/material.dart';
import 'package:image_flutter/res/warna.dart';

class AddMovies extends StatefulWidget {
  const AddMovies({super.key});

  @override
  State<AddMovies> createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController productionController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

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
          'Add Movie',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Expanded(
          child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Form(
                    key: formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Movie Name',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 16),
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Insert the movie name...',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.flag,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Judul can't be empty";
                                }
                                return null;
                              },
                            ),
                          ),
                          Text(
                            'Production House',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 16),
                            child: TextFormField(
                              controller: productionController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Insert the production house...',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.movie_creation,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Judul can't be empty";
                                }
                                return null;
                              },
                            ),
                          ),
                          Text(
                            'Movie Poster',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('OTW Upload')));
                              },
                              child: Container(
                                height: 200,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Warna().lightGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Upload',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Movie',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Poster',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 8),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Add Movie',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ]),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(150, 50)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
