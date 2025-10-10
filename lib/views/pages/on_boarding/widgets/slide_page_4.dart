import "package:crustascan_app/data/_list.dart";
import "package:flutter/material.dart";

class SlidePage4 extends StatelessWidget {
  final PageController controller;
  const SlidePage4({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 200),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/on_boarding_slides/slide_4.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.0),
                Color.fromRGBO(0, 0, 0, 1),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                purposeList[3]['title'] ?? '',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                purposeList[3]['description'] ?? '',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
