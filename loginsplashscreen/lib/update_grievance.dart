import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:archive/archive_io.dart';

class GrievanceScreenUpdate extends StatefulWidget {
  final String title;
  final String desc;
  final String resolutiondate;
  final String status;
  final List<String> imagePaths;
  final String category;

  const GrievanceScreenUpdate({
    super.key,
    required this.title,
    required this.desc,
    required this.resolutiondate,
    required this.status,
    required this.imagePaths,
    required this.category,
  });

  @override
  State<GrievanceScreenUpdate> createState() => _GrievanceScreenUpdateState();
}

class _GrievanceScreenUpdateState extends State<GrievanceScreenUpdate> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  String? _category; // Default category
  List<File> _images = [];
  final List<String> _categories = [ // Corrected: Define _categories list
    'parking',
    'bathrooms',
    'library',
    'classrooms',
  ];
  String? _selectedCategory;
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _description = widget.desc;
    _images = widget.imagePaths.map((path) => File(path)).toList();// Initialize images
    _category = widget.category;
    print("Grievance Category: ${widget.category}");

    if (_categories.contains(widget.category)) {
      _category = widget.category;
    } else {
      _category = _categories.first; // Set to the first category as a default
      print("Warning: Category '${widget.category}' not found. Using default: ${_category}");
    }
  }

  // In update_grievance.dart:
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      List<File> imageFiles = pickedImages.map((xfile) => File(xfile.path)).toList();
      List<File> compressedImages = await _compressImages(imageFiles);
      // Now use compressedImages for upload or display
    }
  }


  Future<List<File>> _compressImages(List<File> images) async {
    List<File> compressedImages = [];
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < images.length; i++) {
      File image = images[i];
      String targetPath = '${image.parent.path}/compressed_$timestamp\_$i.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 85,
      );

      if (compressedFile != null) {
        compressedImages.add(compressedFile as File);
      }
    }

    return compressedImages;
  }
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      _pickImages();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions denied')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Grievance",
            style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Colors.purple.shade900,
                shadows: const [
                  Shadow(
                    blurRadius: 2.0,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    offset: Offset(1.0, 1.0),
                  )
                ])),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              "assets/images/form.gif",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    initialValue: _description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    value: _category,
                    items: _categories.map((String value) { // Corrected: Remove parentheses
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    validator: (value) =>
                    value == null || value.isEmpty ? "Please select a category" : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _requestPermissions,
                    child: const Text('Add Images'),
                  ),
                  const SizedBox(height: 16),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  _images[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => _removeImage(index),
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print("Updated Title: $_title");
                        print("Updated Description: $_description");
                        print("Updated Category: $_category");
                        print("Updated Image Paths: ${_images.map((image) => image.path).toList()}");

                        // Pass updated data back
                        Navigator.pop(context, {
                          'title': _title,
                          'description': _description,
                          'category': _category,
                          'imagePaths': _images.map((image) => image.path).toList(),
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text("Update"),
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