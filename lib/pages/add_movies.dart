import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_flutter/networking/client/dio.dart';
import 'package:image_flutter/res/warna.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';

class AddMovies extends StatefulWidget {
  const AddMovies({super.key});

  @override
  State<AddMovies> createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController productionController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? image;
  String? imageUrl;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      print("Image Bytes ${image.readAsBytes()}");
      print("Image Path: ${image.path}");

      final imageTemp = File(image.path);

      print("Image Temp: $imageTemp");

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> postMovie(BuildContext context) async {
    // Upload Image
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dcnmqlrf8/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'horxoem0'
      ..files.add(await http.MultipartFile.fromPath('file', image!.path));

    context.loaderOverlay.show();

    final response = await request.send();

    context.loaderOverlay.hide();

    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      setState(() {
        final finalUrl = jsonMap['url'];
        imageUrl = finalUrl;
        print("Image URL $imageUrl");
      });

      // Add Movie
      final resp = await DioClient()
          .postMovie(nameController.text, productionController.text, imageUrl!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Add Data Success')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              image == null;
            });
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Movie',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: LoaderOverlay(
        child: Expanded(
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 16),
                                child: InkWell(
                                    onTap: () {
                                      pickImage();
                                    },
                                    child: image == null
                                        ? Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Upload Movie Poster',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.change_circle,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Change Movie Poster',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ))),
                            Container(
                              child: image != null
                                  ? Image.file(image!)
                                  : const Center(),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 8),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    postMovie(context);
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  ),
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
      ),
    );
  }
}
