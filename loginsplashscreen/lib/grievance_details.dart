import 'package:flutter/material.dart';
import 'request_review.dart';
import 'Grievance_list.dart';
import 'dart:io';
import 'grievances_class.dart';

import 'update_grievance.dart';

class GrievanceDetails extends StatefulWidget {
  final Grievance grievance;

  const GrievanceDetails({super.key, required this.grievance});
  @override
  State<GrievanceDetails> createState() => _GrievanceDetailsState();
}

class _GrievanceDetailsState extends State<GrievanceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grievance Details",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.grievance.images.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.grievance.images.map((image) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          image.path.startsWith('http')
                              ? image.path
                              : 'http://192.168.1.8:8000${image.path}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 100, color: Colors.grey);
                          },
                        ),

                      ),
                    );
                  }).toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Title: ",
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.grievance.title,
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Description: ",
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.grievance.description,
                          style: const TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Status: ",
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.grievance.status,
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("Submitted: ",
                              style: TextStyle(fontSize: 15, color: Colors.black38)),
                          const SizedBox(width: 5),
                          Text(
                            widget.grievance.date,
                            style: const TextStyle(
                                fontFamily: 'Lexend', fontSize: 16, color: Colors.black38),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Resolution: ",
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("Resolution Date ",
                              style: TextStyle(fontSize: 15, color: Colors.black38)),
                          const SizedBox(width: 5),
                          Text(
                            widget.grievance.resolutionDate,
                            style: const TextStyle(
                                fontFamily: 'Lexend', fontSize: 16, color: Colors.black38),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Actions: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Request a Review",
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => RequestReview()));
                      },
                      icon: Icon(Icons.arrow_forward)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add an Update",
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrievanceScreenUpdate(
                            title: widget.grievance.title,
                            desc: widget.grievance.description,
                            resolutiondate: widget.grievance.resolutionDate,
                            status: widget.grievance.status,
                            imagePaths: widget.grievance.images.map((image) => image.path).toList(),
                            category: widget.grievance.category,

                          ),
                        ),
                      ).then((updatedData) {
                        if (updatedData != null) {
                          setState(() {
                            widget.grievance.title = updatedData['title'];
                            widget.grievance.description = updatedData['description'];
                            widget.grievance.category = updatedData['category'];
                            widget.grievance.images = (updatedData['imagePaths'] as List<String>).map((path) => GrievanceImage(path: path)).toList();
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}