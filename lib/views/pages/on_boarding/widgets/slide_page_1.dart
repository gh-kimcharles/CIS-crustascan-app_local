import "package:crustascan_app/views/pages/auth/login_page.dart";
import "package:crustascan_app/views/widgets/global_loading_page.dart";
import 'package:crustascan_app/data/_list.dart';
import "package:flutter/material.dart";

class SlidePage1 extends StatelessWidget {
  final PageController controller;
  const SlidePage1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/on_boarding_slides/slide_1.png"),
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
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 125),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                purposeList[0]['title'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                purposeList[0]['description'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 80),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 189, 25, 33),
                  ),
                  child: Text(
                    "GET STARTED!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GlobalLoadingPage(
                            navigateNextPage: LoginPage(),
                            duration: Duration(seconds: 1),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 219, 201, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
