// To parse this JSON data, do
//
//     final movies = moviesFromJson(jsonString);

import 'dart:convert';

Movies moviesFromJson(String str) => Movies.fromJson(json.decode(str));

String moviesToJson(Movies data) => json.encode(data.toJson());

class Movies {
  int id;
  String name;
  String production;
  String image;

  Movies({
    required this.id,
    required this.name,
    required this.production,
    required this.image,
  });

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
        id: json["id"],
        name: json["name"],
        production: json["production"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "production": production,
        "image": image,
      };
}
