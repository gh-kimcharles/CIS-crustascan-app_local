import "package:crustascan_app/views/pages/auth/login_page.dart";
import "package:crustascan_app/views/widgets/global_loading_page.dart";
import "package:flutter/material.dart";
import "package:crustascan_app/views/pages/on_boarding/widgets/slide_page_1.dart";
import "package:crustascan_app/views/pages/on_boarding/widgets/slide_page_2.dart";
import "package:crustascan_app/views/pages/on_boarding/widgets/slide_page_3.dart";
import "package:crustascan_app/views/pages/on_boarding/widgets/slide_page_4.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:shared_preferences/shared_preferences.dart";

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _controller = PageController();
  bool _onLastPage = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _onLastPage = _controller.page?.round() == 3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              SlidePage1(controller: _controller),
              SlidePage2(controller: _controller),
              SlidePage3(controller: _controller),
              SlidePage4(controller: _controller),
            ],
          ),

          // Show PageIndicator or Button
          _onLastPage
              ? Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Save flag that onboarding is complete
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('onboarding_completed', true);

                          // Navigate to Login and clear stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GlobalLoadingPage(
                                navigateNextPage: LoginPage(),
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 189, 25, 33),
                        ),
                        child: Text(
                          "START NOW!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              : PageIndicator(pageController: _controller),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0.85),
      child: SmoothPageIndicator(
        controller: pageController,
        count: 4,
        effect: ExpandingDotsEffect(
          dotHeight: 8,
          dotWidth: 8,
          spacing: 4.0,
          activeDotColor: Color.fromARGB(255, 114, 22, 26),
        ),
      ),
    );
  }
}
