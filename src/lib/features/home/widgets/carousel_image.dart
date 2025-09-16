import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/constants/global_veriables.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return cs.CarouselSlider(
      items: GlobalVariables.carouselImages.map(
        (i) {
          return Builder(
            builder: (BuildContext context) => Image.asset(
              i,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          );
        },
      ).toList(),
      options: cs.CarouselOptions(
        viewportFraction: 1,
        height: 240,
      ),
    );
  }
}