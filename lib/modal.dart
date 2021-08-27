import 'package:flutter/material.dart';
import 'dart:convert';

class Album {
  final String userId;
  final String id;
  final String title;
  final String bg;

  Album({
    this.userId,
    this.id,
    this.title,
    this.bg,
  });

  factory Album.fromJson(Map<dynamic, dynamic> json) {
    // print(json);
    return Album(
      bg: json['coverart'],
        userId: json['nowplaying'],
      id: json['servername'],
      title: json['nowplaying'],
    );
  }
}