import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_flutter/networking/client/dio.dart';
import 'package:image_flutter/pages/home.dart';
import 'package:image_flutter/res/warna.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';
import 'package:process_run/process_run.dart'; // Import process_run

class AddMovies extends StatefulWidget {
  const AddMovies({super.key});

  @override
  State<AddMovies> createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController productionController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  XFile? image;
  String? imageUrl;

  Future<bool> checkSuspiciousFile(
      XFile pickedImage, BuildContext context) async {
    var imageAsBytes = await pickedImage.readAsBytes();
    // Convert all bytes into one single hex string
    String hexString = imageAsBytes.map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join();

    // List of suspicious text
    List<String> suspiciousCommands = [
      '414c544552', // ALTER
      '616c746572', // alter
      '65786563', // exec
      '45584543', // EXEC
      '65786563757465', // execute
      '45584543555445', // EXECUTE
      '64726f70', // drop
      '44524f50', // DROP
      '73656c656374', // select
      '53454c454354', // SELECT
      '68746d6c', // html
      '48544d4c', // HTML
      '637265617465', // create
      '435245415445' // CREATE
    ];

    for (String command in suspiciousCommands) {
      if (hexString.contains(command)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File is Suspicious!")),
        );
        context.loaderOverlay.hide();
        return false;
      }
    }

    print("Hex Values Length: ${hexString.length ~/ 2}");
    print("Image Path: ${pickedImage.path}");
    return true;
  }

  Future<bool> validateImage(BuildContext context) async {
    try {
      var pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      context.loaderOverlay.show();

      var imageFile = File(pickedImage!.path);
      int fileSize = await imageFile.length();
      int maxFileSizeInBytes = 5 * 1024 * 1024;

      // Null Checking
      if (pickedImage == null) {
        context.loaderOverlay.hide();
        return false;
      }

      // File Size Checking (Must be less than 5 MB [Mega Bytes] )
      if (fileSize >= maxFileSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File size is more than 5MB")));
        context.loaderOverlay.hide();
        return false;
      }

      // Suspicious File Checking
      var result = await checkSuspiciousFile(pickedImage, context);
      if (result == false) {
        context.loaderOverlay.hide();
        return false;
      }

      setState(() {
        image = pickedImage;
      });
      context.loaderOverlay.hide();
      return true;
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
      return false;
    }
  }

  bool gambar = true;
  Future pickImage(BuildContext context) async {
    try {
      var result = await validateImage(context);
      print("Berjalan!!");
      context.loaderOverlay.show();
      print("Result = $result");

      var imageAsBytes = await image!.readAsBytes();
      XFile imageTemp;

      print("Bool Gambar: $gambar");

      if (result == true) {
        File compressedFile =
            await FlutterNativeImage.compressImage(image!.path, quality: 50);
        imageTemp = XFile(compressedFile.path);

        if (image!.path.endsWith("png") ||
            image!.path.endsWith("jpeg") ||
            image!.path.endsWith("jpg")) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("File extension is not allowed")));
          return false;
        }
        setState(() {
          image = imageTemp;
        });
      }
      context.loaderOverlay.hide();
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
          .showSnackBar(SnackBar(content: Text('Add Movie Success')));
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
                                    return "Movie name can't be empty";
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
                                    return "Production house can't be empty";
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
                                      pickImage(context);
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
                                  ? Center(child: Image.file(File(image!.path)))
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
                                    if (image != null) {
                                      postMovie(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  ("Movie Poster can't be empty"))));
                                    }
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
