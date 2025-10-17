import 'package:crustascan_app/services/network_service.dart';
import 'package:crustascan_app/models/history_model.dart';
import 'package:crustascan_app/views/pages/history/history_details_page.dart';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_bottom_navigation_bar.dart';
import 'package:crustascan_app/views/pages/home/widgets/custom_floating_action_button.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:crustascan_app/views/widgets/global_no_connection_widget.dart';
import 'package:crustascan_app/services/config.dart';
import 'package:crustascan_app/utils/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/history_provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crustascan_app/services/config.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with ConnectionMonitorMixin {
  @override
  void initState() {
    super.initState();
    initializeConnectionMonitoring();
  }

  @override
  void dispose() {
    disposeConnectionMonitoring();
    super.dispose();
  }

  Widget _buildHistoryContent() {
    final historyList = Provider.of<HistoryProvider>(context).historyList;

    // Sort by newest first
    final sortedList = [...historyList]
      ..sort((a, b) => b.date.compareTo(a.date));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: sortedList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                    SizedBox(height: 16),
                    Text(
                      "You have no history yet.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Start scanning to see your history here!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView(
                children: [
                  SizedBox(height: 20),
                  ...sortedList.map((item) => HistoryContainer(history: item)),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: 'History', navigatePage: HomePage()),
      body: Column(
        children: [
          //NetworkTestWidget(),
          Expanded(
            child: hasConnection
                ? _buildHistoryContent()
                : GlobalNoConnectionWidget(isExpanded: false),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HistoryContainer extends StatelessWidget {
  final History history;

  const HistoryContainer({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryDetailsPage(history: history),
            ),
          );
        },
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) =>
                DeleteHistoryModalSheetButton(history: history),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildHistoryImage(history.imagePath),
                ),
              ),

              SizedBox(width: 16),

              // Content section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, y').format(history.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Handles different image sources
  Widget _buildHistoryImage(String imagePath) {
    return ImageHelper.buildImage(
      imagePath: imagePath,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
    );
  }

  // Helper: Default fallback image
  Widget _errorImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade400,
        size: 24,
      ),
    );
  }
}

class DeleteHistoryModalSheetButton extends StatelessWidget {
  final History history;

  const DeleteHistoryModalSheetButton({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Remove this: color: Colors.white,
      // Add this instead:
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 60),
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              "Remove ${history.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 4),

            // Subtitle (history name)
            Text(
              "This action cannot be undone.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Remove Button (Red - Destructive)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<HistoryProvider>(
                    context,
                    listen: false,
                  ).removeHistory(context, history);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// class NetworkTestWidget extends StatefulWidget {
//   const NetworkTestWidget({super.key});
//
//   @override
//   State<NetworkTestWidget> createState() => _NetworkTestWidgetState();
// }
//
// class _NetworkTestWidgetState extends State<NetworkTestWidget> {
//   String _status = 'Testing...';
//   Color _statusColor = Colors.orange;
//
//   @override
//   void initState() {
//     super.initState();
//     _testConnection();
//   }
//
//   Future<void> _testConnection() async {
//     try {
//       debugPrint('🔍 Testing connection to: ${AppConfig.baseUrl}');
//
//       // Test 1: Health check
//       final healthResponse = await http
//           .get(Uri.parse('${AppConfig.baseUrl}/health'))
//           .timeout(Duration(seconds: 5));
//
//       if (healthResponse.statusCode == 200) {
//         debugPrint('✅ Health check passed');
//
//         // Test 2: Try to fetch an actual image
//         final testImageUrl =
//             '${AppConfig.baseUrl}/uploads/history_2a2cc608-2439-47d2-8d32-83af57229e7a_f9312985.jpg';
//         debugPrint('🔍 Testing image URL: $testImageUrl');
//
//         final imageResponse = await http
//             .get(Uri.parse(testImageUrl))
//             .timeout(Duration(seconds: 5));
//
//         if (imageResponse.statusCode == 200) {
//           debugPrint('✅ Image fetch successful');
//           setState(() {
//             _status = '✅ Connected!\nBase: ${AppConfig.baseUrl}';
//             _statusColor = Colors.green;
//           });
//         } else {
//           debugPrint('❌ Image fetch failed: ${imageResponse.statusCode}');
//           setState(() {
//             _status =
//                 '⚠️ API OK, but image failed\nStatus: ${imageResponse.statusCode}';
//             _statusColor = Colors.orange;
//           });
//         }
//       } else {
//         debugPrint('❌ Health check failed: ${healthResponse.statusCode}');
//         setState(() {
//           _status = '❌ API Error: ${healthResponse.statusCode}';
//           _statusColor = Colors.red;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Connection test failed: $e');
//       setState(() {
//         _status = '❌ Cannot reach server\n${AppConfig.baseUrl}\nError: $e';
//         _statusColor = Colors.red;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // margin: EdgeInsets.all(16),
//       // padding: EdgeInsets.all(16),
//       // decoration: BoxDecoration(
//       //   color: _statusColor.withOpacity(0.1),
//       //   border: Border.all(color: _statusColor),
//       //   borderRadius: BorderRadius.circular(12),
//       ),
//       // child: Column(
//       //   mainAxisSize: MainAxisSize.min,
//       //   children: [
//       //     Text(
//       //       'Network Status',
//       //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       //     ),
//       //     SizedBox(height: 8),
//       //     Text(
//       //       _status,
//       //       textAlign: TextAlign.center,
//       //       style: TextStyle(fontSize: 12),
//       //     ),
//       //     SizedBox(height: 8),
//       //     ElevatedButton(onPressed: _testConnection, child: Text('Test Again')),
//       //   ],
//       // ),
//     );
//   }
// }
