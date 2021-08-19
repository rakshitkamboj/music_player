import 'package:flutter/material.dart';
import 'dart:convert';

class Album {
  final String userId;
  final String id;
  final String title;

  Album({
    this.userId,
    this.id,
    this.title,
  });

  factory Album.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    return Album(
        userId: json['nowplaying'],
      id: json['servername'],
      title: json['nowplaying'],
    );
  }
}