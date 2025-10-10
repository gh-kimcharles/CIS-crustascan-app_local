import 'dart:io';
import 'dart:async';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/pages/identifier/widget/bracket_painter.dart';
import 'package:flutter/services.dart';
import 'package:crustascan_app/services/api_service.dart';
import 'package:crustascan_app/views/pages/identifier/predict_page.dart';
import 'package:flutter/material.dart';
import 'package:crustascan_app/data/crustacean_data.dart';
import 'package:crustascan_app/models/crustacean_model.dart';

class IdentifierPage extends StatefulWidget {
  final File imageFile;
  final Duration duration;
  const IdentifierPage({
    super.key,
    required this.imageFile,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<IdentifierPage> createState() => _IdentifierPageState();
}

class _IdentifierPageState extends State<IdentifierPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanAnimation;

  Timer? _stepTimer;
  final List<String> steps = ["Identifying species..."];
  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    // scan animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 600 - 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // start prediction immediately
    _predictSpecies();

    // cycle through step messages
    _stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (currentStep < steps.length - 1) {
          currentStep++;
        } else {
          _stepTimer?.cancel();
        }
      });
    });
  }

  Future<void> _predictSpecies() async {
    try {
      final imageBytes = await widget.imageFile.readAsBytes();

      final result = await ApiService.sendImageForPrediction(imageBytes)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException("Server took too long to respond (30s).");
            },
          );

      if (!mounted) return;

      final Crustacean species = crustaceanList.firstWhere(
        (speciesItem) => speciesItem.id == result['class'],
        orElse: () {
          throw Exception("Species with id '${result['class']}' not found.");
        },
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PredictPage(
            imageFile: widget.imageFile,
            confidence: "${(result['confidence'] * 100).toStringAsFixed(1)}%",
            speciesId: result['class'],
            type: species.type,
            speciesName: species.name,
            scientificName: species.scientificName,
            familyName: species.familyName,
            population: species.population,
            description: species.shortDescription,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is TimeoutException
                ? "Prediction failed: Server did not respond in 30 seconds."
                : "Prediction failed: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _stepTimer?.cancel();
    super.dispose();
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
                  Color.fromRGBO(0, 0, 0, 0.6),
                ],
              ),
            ),
          ),

          // Scanning frame with image
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: SizedBox(
                height: 600,
                width: 350,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SizedBox.expand(
                          child: Image.file(
                            widget.imageFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(painter: BracketPainter()),
                    ),

                    // Scanning animation line
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanAnimation.value,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 12,
                              width: 280,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white.withOpacity(0.6),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom loading UI
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.black26,
                      strokeWidth: 6,
                    ),
                  ),
                  const SizedBox(height: 15),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Text(
                      steps[currentStep],
                      key: ValueKey(currentStep),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
