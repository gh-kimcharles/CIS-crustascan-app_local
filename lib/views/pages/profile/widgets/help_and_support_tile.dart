import 'package:flutter/material.dart';

class HelpAndSupportTile extends StatelessWidget {
  final String title;
  final String description;

  const HelpAndSupportTile({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        // border: Border.all(color: Colors.grey.shade300),
        // boxShadow: [
        //   BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        // ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // remove divider line
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
