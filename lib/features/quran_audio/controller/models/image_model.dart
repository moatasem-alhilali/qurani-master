import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class Photo {
  int? id;
  String? photo_name;
  String? title;
  String? content;
  int? price;

  Photo({this.photo_name, this.content, this.price, this.title});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'picture': photo_name,
      'content': content,
      'price': price,
      'title': title,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photo_name = map['picture'];
    content = map['content'];
    price = map['price'];
    title = map['title'];
  }
}

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
