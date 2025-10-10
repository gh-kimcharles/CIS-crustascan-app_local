import 'package:flutter/material.dart';

class GlobalLoadingPage extends StatefulWidget {
  final Widget navigateNextPage;
  final Duration duration;
  const GlobalLoadingPage({
    super.key,
    required this.navigateNextPage,
    this.duration = const Duration(seconds: 2), // load the screen 2 seconds
  });

  @override
  State<GlobalLoadingPage> createState() => _GlobalLoadingPageState();
}

class _GlobalLoadingPageState extends State<GlobalLoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.navigateNextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 126, 17, 22)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.0),
                  Color.fromRGBO(0, 0, 0, 0.9),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logos/cis_logo2.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 3,
                  width: 60,
                  child: LinearProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
