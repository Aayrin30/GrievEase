import 'dart:io';

class Grievance {
  final String title;
  final String description;
  final String date;
  final String status;
  final String resolutionDate;
  final List<File> images; // Use List<String> if storing URLs instead

  Grievance({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.resolutionDate,
    required this.images,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      status: json['status'],
      resolutionDate: json['resolution_date'] ?? '',
      images: (json['images'] as List)
          .map((imgUrl) => File(imgUrl)) // Or just keep as String if they're URLs
          .toList(),
    );
  }
}
