import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final List<Color> coverGradient;
  final double rating;
  final String price;
  final bool hasRent;
  final double? progress;
  final String? pages;
  final String? expiry;
  final bool isCompleted;

  const Book({
    required this.title,
    required this.author,
    required this.coverGradient,
    required this.rating,
    required this.price,
    this.hasRent = false,
    this.progress,
    this.pages,
    this.expiry,
    this.isCompleted = false,
  });
}
