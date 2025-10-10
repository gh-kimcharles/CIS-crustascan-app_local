class History {
  final int id;
  final DateTime date;
  final String imagePath;
  final String name;
  final String confidence;
  final String speciesId; // important

  const History({
    required this.id,
    required this.date,
    required this.imagePath,
    required this.name,
    required this.confidence,
    required this.speciesId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
      'name': name,
      'confidence': confidence,
      'speciesId': speciesId,
    };
  }

  // Updated fromMap to handle both number (from backend) and string (local)
  factory History.fromMap(Map<String, dynamic> map) {
    // Handle confidence from backend (number) or local (string)
    String confidenceStr;
    if (map['confidence'] is num) {
      confidenceStr = "${map['confidence']}%";
    } else {
      confidenceStr = map['confidence'].toString();
      if (!confidenceStr.contains('%')) {
        confidenceStr = "$confidenceStr%";
      }
    }

    return History(
      id: map['id'],
      date: DateTime.parse(map['date']),
      imagePath: map['imagePath'],
      name: map['name'],
      confidence: confidenceStr,
      speciesId: map['speciesId'],
    );
  }
}
