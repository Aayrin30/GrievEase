// ElevatedButton(
//   onPressed: () {
//     // Log Out action
//   },
//   style: ElevatedButton.styleFrom(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 16, vertical: 12),
//       textStyle: const TextStyle(
//           fontSize: 16, fontWeight: FontWeight.bold),
//       backgroundColor: const Color(0xFF4A148C),
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8))
//
//   ),
//   child: const Text("Log Out"),
//
// ),


// Top Section (Profile)
Container(
padding: const EdgeInsets.all(16.0),
decoration: const BoxDecoration(
color: Colors.white,
),
child: Column(
children: [
Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
IconButton(
onPressed: () {
// Settings action
},
icon: const Icon(Icons.settings),
),
],
),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
CircleAvatar(
radius: 48,
backgroundImage: NetworkImage(
"https://cdn.usegalileo.ai/sdxl10/904e5bc3-740b-435d-a3b2-797cdf4acb95.png"),
),
],
),
const SizedBox(height: 16),
const Text(
"Hey, Monica!",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),
const Text(
"Welcome Home!",
style: TextStyle(fontSize: 16),
textAlign: TextAlign.center,
),
const SizedBox(height: 16),
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
ElevatedButton(
onPressed: () {
// Edit Profile action
},
style: ElevatedButton.styleFrom(
padding: const EdgeInsets.symmetric(
horizontal: 16, vertical: 12),
textStyle: const TextStyle(
fontSize: 16, fontWeight: FontWeight.bold),
backgroundColor: const Color(0xFFf0f2f4),
foregroundColor: Colors.black,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8)
)
),
child: const Text("Edit Profile"),
),



ElevatedButton(
onPressed: () {

},
style:  ElevatedButton.styleFrom(
padding: EdgeInsets.zero, // Remove default padding
elevation: 0, // Remove default elevation
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
backgroundColor: Colors.white70,
),
child: Ink( // Use Ink for gradient
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(8),
gradient: const LinearGradient( // Add const
colors: [
Color(0xFF4A148C), // Darker purple (start)
Color(0xFF7B1FA2), // Lighter purple (end)
],
begin: Alignment.centerLeft,
end: Alignment.centerRight,
),

),
child: Container(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Add const
child: Row(
mainAxisSize: MainAxisSize.min,
children: const [
Text(
'Logout',
style: TextStyle(color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
],
),
),
),
),

],
),
],
),
),











Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
//welcome desc
Container(
decoration: const BoxDecoration(
image: DecorationImage(
image: NetworkImage(
"https://cdn.usegalileo.ai/sdxl10/6f489174-6d36-4204-9b1a-9b44370e9b29.png",
),
fit: BoxFit.cover,
),
),
height: 218,
child: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.bottomCenter,
end: Alignment.topCenter,
colors: [
Color.fromRGBO(0, 0, 0, 0.4),
Color.fromRGBO(0, 0, 0, 0),
],
),
),
padding: const EdgeInsets.all(16.0),
alignment: Alignment.bottomLeft,
child: const Text(
"Welcome to GrievEase!",
style: TextStyle(
color: Colors.white,
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
),
),
Padding(
padding: const EdgeInsets.symmetric(
vertical: 8.0, horizontal: 16.0),
child: const Text(
"Your platform for submitting grievances and providing feedback on your faculty.",
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w400,
shadows: const [
Shadow(
blurRadius: 2.0,
color: Color.fromRGBO(0, 0, 0, 0.3),
// Black with 20% opacity
offset: Offset(1.0, 1.0),
)
]
),
),
),
// Middle Section (Actions)
Expanded(
child: Padding(
padding: const EdgeInsets.symmetric(
horizontal: 16.0, vertical: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"What would you like to do today?",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 16),
_buildActionRow(context, Icons.upload_file,
"My Grievances", "View grievances status",
MyGrievancesScreen()),
_buildActionRow(context, Icons.edit,
"Faculty Feedback", "Provide feedback",
FacultyFeedbackScreen()),
],
),
),
),

// Bottom Navigation
Container(
decoration: const BoxDecoration(
border: Border(
top: BorderSide(color: Color(0xFFf0f2f4)),
),
color: Colors.white,
),
padding:
const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildBottomNavItem(Icons.home, "Home",0),
_buildBottomNavItem(Icons.upload_file, "Grievances",1),
_buildBottomNavItem(Icons.settings, "Settings",2),
],
),
),
],
),




SizedBox(height: 5,),

SizedBox(height: 5,),
Text(
status,
style: const TextStyle(
fontFamily: 'Lexend',
fontSize: 18,
fontWeight: FontWeight.w400,
color: Colors.blue,
),
),



grievance list
import 'package:flutter/material.dart';
import 'grievance_details.dart';
import 'grievance_form_screen.dart';

class MyGrievancesScreen extends StatelessWidget {
const MyGrievancesScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
automaticallyImplyLeading: false,
title: Text("MyGrievances",
style: TextStyle(
fontFamily: 'Lato',
fontSize: 23,
fontWeight: FontWeight.w800,
color: Colors.purple[900],
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
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
_buildGrievanceCard(
context: context,
imageUrl:
"https://cdn.usegalileo.ai/sdxl10/1d462ec7-39d9-4396-abde-d12fbd51cb36.png",
title: "Grievance with grade 1",
status: "InProgress",
date: "01/11/22",
desc: "Description 1",
resolutiondate: "10/11/22",
),
_buildGrievanceCard(
context: context,
imageUrl:
"https://cdn.usegalileo.ai/sdxl10/72c87d7c-6eab-4dda-8912-83a08acd5a80.png",
title: "Grievance with grade 2",
status: "Completed",
date: "01/10/22",
desc: "Description 2",
resolutiondate: "10/10/22",
),
_buildGrievanceCard(
context: context,
imageUrl:
"https://cdn.usegalileo.ai/sdxl10/2e28f42f-87f1-4398-9a1a-18239b81dfd7.png",
title: "Grievance with grade 3",
status: "InActive",
date: "01/07/22",
desc: "Description 3",
resolutiondate: "10/07/22",
),
],
),
),
),
floatingActionButton: FloatingActionButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder: (context) => GrievanceFormScreen()),
);
},
backgroundColor: const Color(0xFF1980e6),
child: const Icon(Icons.add),
),
);
}

Widget _buildGrievanceCard({
required BuildContext context,
required String imageUrl,
required String title,
required String date,
required String status,
required String desc,
required String resolutiondate,
}) {
return Card(
margin: const EdgeInsets.only(bottom: 16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Image.network(
imageUrl,
fit: BoxFit.cover,
height: 200,
width: double.infinity,
),
Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: const TextStyle(
fontFamily: 'Lexend',
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 2),
Text(
status,
style: const TextStyle(
fontFamily: 'Lexend',
fontSize: 18,
fontWeight: FontWeight.w400,
color: Colors.blue,
),
),
const SizedBox(height: 8),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.start,
children: [
Text("Submitted on ",style: TextStyle(fontSize: 15,fontFamily: 'Lexend', fontWeight: FontWeight.normal,color: Colors.black38),),
SizedBox(width: 5,),
Text(
date,
style: const TextStyle(
fontFamily: 'Lexend',
fontSize: 16,
fontWeight: FontWeight.normal,
color: Colors.black38
),
),
],
),
ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => GrievanceDetails(
title: title,
desc: desc,
date: date,
resolutiondate: resolutiondate,
status: status,
),
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF1980e6),
foregroundColor: Colors.white,
textStyle: const TextStyle(fontSize: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8.0),
),
),
child: const Text("Open"),
),
],
),
],
),
),
],
),
);
}
}