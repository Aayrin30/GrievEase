import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';  // Make sure you import Dio
import 'package:shared_preferences/shared_preferences.dart';
import 'grievances_class.dart';
import 'GlobalData.dart';
import '../model/Category.dart';
import '../services/api_service.dart';

class GrievanceFormScreen extends StatefulWidget {
  const GrievanceFormScreen({super.key});

  @override
  State<GrievanceFormScreen> createState() => _GrievanceFormScreenState();
}

// ... same imports ...

class _GrievanceFormScreenState extends State<GrievanceFormScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  List<Category> _categories = [];
  Category? _selectedCategory;
  List<GrievanceImage> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // fetch categories on load
  }

  Future<void> _fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await dio.get(
        'http://192.168.1.8:8000/faculty/categories/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Category API response: ${response.data}');
      if (response.statusCode == 200) {
        List data = response.data;
        setState(() {
          // Map category data safely with default values if categoryId is null
          _categories = data.map((e) {
            return Category(
              id: e['categoryId'] != null ? e['categoryId'] : 0, // Default to 0 if null
              name: e['categoryName'] ?? 'Unknown', // Default to 'Unknown' if null
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }


  Future<void> _pickImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _selectedImages.addAll(pickedImages.map((x) => GrievanceImage(path: x.path)));
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile? captured = await _picker.pickImage(source: ImageSource.camera);
    if (captured != null) {
      setState(() {
        _selectedImages.add(GrievanceImage(path: captured.path));
      });
    }
  }

  Future<void> _submitGrievance() async {
    if (title.text.isEmpty ||
        description.text.isEmpty ||
        _selectedCategory == null ||
        _selectedImages.isEmpty) {
      _showAlert("Please fill all fields and select at least one image.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      _showAlert("No token found. Please log in again.");
      return;
    }

    try {
      FormData formData = FormData.fromMap({
        'title': title.text,
        'description': description.text,
        'category': _selectedCategory!.id.toString(), // assuming backend expects ID
        'images': await Future.wait(_selectedImages.map(
              (img) => MultipartFile.fromFile(img.path, filename: img.path.split('/').last),
        )),
      });

      final response = await dio.post(
        'http://192.168.1.8:8000/faculty/grievance/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        _showAlert("Grievance submitted successfully!", success: true);
      } else {
        print(response.data);
        _showAlert("Failed to submit grievance.");
      }
    } catch (e) {
      print("Error: $e");
      _showAlert("Error submitting grievance.");
    }
  }

  void _showAlert(String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Success' : 'Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Grievance")),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: description,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory, // This will hold the selected category
                  decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                  items: _categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category, // Each category in the list
                      child: Text(category.name), // Display the category name in the dropdown
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue; // Update the selected category
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _pickImage, child: const Text("Pick from Gallery")),
                ElevatedButton(onPressed: _captureImage, child: const Text("Capture Image")),
                const SizedBox(height: 16),
                if (_selectedImages.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Selected Images:"),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.file(File(_selectedImages[i].path), width: 80, height: 80),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitGrievance,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'grievances_class.dart';
// import 'GlobalData.dart';
//
// class GrievanceFormScreen extends StatefulWidget {
//   const GrievanceFormScreen({super.key});
//
//   @override
//   State<GrievanceFormScreen> createState() => _GrievanceFormScreenState();
// }
//
// class _GrievanceFormScreenState extends State<GrievanceFormScreen> {
//   TextEditingController title = TextEditingController();
//   TextEditingController description = TextEditingController();
//   String? _selectedCategory;
//   List<GrievanceImage> _selectedImages = [];
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     try {
//       final List<XFile>? pickedImages = await _picker.pickMultiImage();
//       if (pickedImages != null) {
//         setState(() {
//           _selectedImages.addAll(
//             pickedImages.map((xFile) => GrievanceImage(path: xFile.path)).toList(),
//           );
//         });
//       }
//     } catch (e) {
//       print('Error picking images: $e');
//     }
//   }
//
//   Future<void> _captureImage() async {
//     try {
//       final XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);
//       if (capturedImage != null) {
//         setState(() {
//           _selectedImages.add(GrievanceImage(path: capturedImage.path));
//         });
//       }
//     } catch (e) {
//       print('Error capturing image: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Submit Grievance")),
//       body: Stack(
//         children: [
//           Opacity(
//             opacity: 0.2,
//             child: Image.asset(
//               "assets/images/form.gif",
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//             ),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: "Title",
//                     border: OutlineInputBorder(),
//                   ),
//                   controller: title,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: "Description",
//                     border: OutlineInputBorder(),
//                   ),
//                   controller: description,
//                   maxLines: 4,
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: "Category",
//                     border: OutlineInputBorder(),
//                   ),
//                   value: _selectedCategory,
//                   items: Grievance(
//
//
//                   ).categories.map((String category) {
//                     return DropdownMenuItem<String>(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedCategory = newValue;
//                     });
//                   },
//                   validator: (value) => value == null ? "Please select a category" : null,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _pickImage,
//                   child: const Text("Pick an Image from Gallery"),
//                 ),
//                 ElevatedButton(
//                   onPressed: _captureImage,
//                   child: const Text("Capture an Image"),
//                 ),
//                 const SizedBox(height: 16),
//                 if (_selectedImages.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Selected Images:'),
//                       const SizedBox(height: 8),
//                       Container(
//                         height: 100,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: _selectedImages.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: Image.file(
//                                 File(_selectedImages[index].path),
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (title.text.isNotEmpty &&
//                         description.text.isNotEmpty &&
//                         _selectedCategory != null &&
//                         _selectedImages.isNotEmpty) {
//                       Grievance newGrievance = new Grievance();
//                       newGrievance.title = title.text;
//                       newGrievance.description =  description.text;
//                       newGrievance.category = _selectedCategory!;
//                       newGrievance.images = _selectedImages;
//                       GlobalData.lstGrievances.add(newGrievance);
//                       print(GlobalData.lstGrievances.length);
//                       Navigator.pop(context);
//                     } else {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Error'),
//                           content: const Text('Please fill all fields and select images.'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text('OK'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   ),
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
