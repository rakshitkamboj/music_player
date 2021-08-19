import 'package:flutter/material.dart';
import 'dart:convert';

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    this.userId,
    this.id,
    this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        userId: json['nowplaying'],
      id: json['servername'],
      title: json['nowplaying'],
    );
  }
}