import 'package:flutter/material.dart';

String uri = 'http://172.240.29.18:3000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );
  
  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'assets/images/Screenshot 2025-08-13 223418.png',
    'assets/images/view-gym-room-training-sports.jpg',
    
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Gym',
      'image': 'assets/images/fitness-app.png',
    },
    {
      'title': 'Calisthenics',
      'image': 'assets/images/workout.png',
    },
    {
      'title': 'Yoga',
      'image': 'assets/images/yoga.png',
    },
    {
      'title': 'Sports',
      'image': 'assets/images/sports.png',
    },
    {
      'title': 'Accessories',
      'image': 'assets/images/sport.png',
    },
  ];
}