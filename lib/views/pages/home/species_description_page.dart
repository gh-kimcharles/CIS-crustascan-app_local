import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';

class SpeciesDescriptionPage extends StatefulWidget {
  final String speciesId;
  final String speciesImage;
  final String tag;
  final String type;
  final String speciesName;
  final String scientificName;
  final String familyName;
  final String population;
  final String speciesDescription;
  final String sampleImage;
  final String imageDescription;

  const SpeciesDescriptionPage({
    super.key,
    required this.speciesId,
    required this.speciesImage,
    required this.tag,
    required this.type,
    required this.speciesName,
    required this.scientificName,
    required this.familyName,
    required this.population,
    required this.speciesDescription,
    required this.sampleImage,
    required this.imageDescription,
  });

  @override
  State<SpeciesDescriptionPage> createState() => _SpeciesDescriptionPageState();
}

class _SpeciesDescriptionPageState extends State<SpeciesDescriptionPage> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _imageHeight = 600; // Starting height

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        // Map the draggable size (0.45 to 0.95) to image height (200 to 600)
        final double factor = _controller.size; // 0.45 to 0.95

        // Normalize factor from 0.45-0.95 range to 0-1 range
        final double normalizedFactor = (factor - 0.45) / (0.95 - 0.45);

        // Invert the factor so image shrinks as sheet expands
        final double invertedFactor = 1 - normalizedFactor;

        // Map to desired height range (200 to 600)
        _imageHeight = 200 + (invertedFactor * 400);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dynamic image height with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: _imageHeight,
            width: double.infinity,
            child: ClipRect(
              child: Hero(
                tag: widget.tag,
                child: Image.asset(
                  widget.speciesImage,
                  width: double.infinity,
                  height: _imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Top icons overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (authProvider.isUser)
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        final isFav = userProvider.isFavorite(widget.speciesId);
                        return Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.black,
                              size: 24,
                            ),
                            onPressed: () =>
                                userProvider.toggleFavorite(widget.speciesId),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Draggable scrollable sheet
          DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: 0.45, // Start lower to show more image
            minChildSize: 0.45, // Minimum size
            maxChildSize: 0.95, // Maximum size
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          // Species type badge and name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.type == 'Crab'
                                      ? const Color.fromARGB(255, 253, 220, 220)
                                      : widget.type == 'Shrimp'
                                      ? const Color.fromARGB(255, 253, 243, 220)
                                      : widget.type == 'Prawn'
                                      ? const Color.fromARGB(255, 253, 243, 220)
                                      : widget.type == 'Lobster'
                                      ? const Color.fromARGB(255, 220, 230, 253)
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.type,
                                  style: TextStyle(
                                    color: widget.type == 'Crab'
                                        ? const Color.fromARGB(255, 204, 77, 77)
                                        : widget.type == 'Shrimp'
                                        ? const Color.fromARGB(255, 230, 210, 0)
                                        : widget.type == 'Prawn'
                                        ? const Color.fromARGB(
                                            255,
                                            228,
                                            128,
                                            29,
                                          )
                                        : widget.type == 'Lobster'
                                        ? const Color.fromARGB(255, 29, 92, 228)
                                        : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.speciesName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Info cards (Scientific name, Family, Population)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildInfoCard(
                                  "Scientific Name",
                                  widget.scientificName,
                                ),
                                const SizedBox(width: 12),
                                _buildInfoCard("Family", widget.familyName),
                                const SizedBox(width: 12),
                                _buildInfoCard("Population", widget.population),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Description section
                          Text(
                            'About ${widget.speciesName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.speciesDescription,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Color(0xFF4A5568),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Sample image section
                          _buildSampleImageSection(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.sampleImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.sampleImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            widget.imageDescription,
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
