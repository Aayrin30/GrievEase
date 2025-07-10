import 'package:flutter/material.dart';
class RequestReview extends StatefulWidget {
  const RequestReview({super.key});

  @override
  State<RequestReview> createState() => _RequestReviewState();
}

class _RequestReviewState extends State<RequestReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("We've Successfully Get Your Request!",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',),
            ),
            SizedBox(height: 10,),
            Text("Your request has been received,we will get back to you shortly.Thanks for using GrievEase",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontFamily: 'Lexend',),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                ),
                child: Text("Track Grievance"))
          ],
        ),
      ),
    );
  }
}
