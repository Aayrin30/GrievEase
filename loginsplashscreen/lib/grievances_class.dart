class Grievance {
  String title;
  String description;
  String category;
  List<GrievanceImage> images;
  String status;
  String date;
  String resolutionDate;

  List<String> categories = [
    'parking',
    'bathrooms',
    'library',
    'classrooms',
  ];

  Grievance({
    required this.title,
    required this.description,
    required this.category,
    required this.images,
    required this.status,
    required this.date,
    required this.resolutionDate,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      images: (json['image_urls'] as List<dynamic>? ?? [])
          .map((img) => GrievanceImage.fromJson(img as String))
          .toList(),
      status: json['status'] ?? 'Pending',
      date: json['created_at'] ?? '',
      resolutionDate: json['resolutionDate'] ?? '',
    );
  }
}

class GrievanceImage {
  String path;

  GrievanceImage({required this.path});

  factory GrievanceImage.fromJson(dynamic json) {
    return GrievanceImage(
      path: 'http://192.168.1.8:8000$json', // json is just a string here
    );
  }
}
