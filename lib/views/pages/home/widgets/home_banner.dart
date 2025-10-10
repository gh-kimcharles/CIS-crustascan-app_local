import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  Timer? timer;
  final List<String> bannerImageList = [
    'assets/images/home_page/home_banner/background_image_1.jpg',
    'assets/images/home_page/home_banner/background_image_2.jpg',
    'assets/images/home_page/home_banner/background_image_3.png',
    'assets/images/home_page/home_banner/background_image_4.jpg',
    'assets/images/home_page/home_banner/background_image_5.png',
  ];

  @override
  void initState() {
    super.initState();
    startBannerSlide();
  }

  void startBannerSlide() {
    timer = Timer.periodic(Duration(seconds: 5), (_) {
      currentPage++;
      if (currentPage >= bannerImageList.length) currentPage = 0;
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 18, right: 18),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView.builder(
                controller: _pageController,
                itemCount: bannerImageList.length,
                itemBuilder: (context, index) {
                  return Image.asset(bannerImageList[index], fit: BoxFit.cover);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController,
            count: bannerImageList.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
              spacing: 6,
              activeDotColor: const Color.fromARGB(255, 114, 22, 26),
              dotColor: const Color.fromARGB(255, 211, 211, 211),
            ),
          ),
        ],
      ),
    );
  }
}
