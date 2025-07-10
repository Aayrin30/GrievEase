import 'package:flutter/material.dart';
import 'faculty_feedback.dart';
import 'grievance_list.dart';
import 'settings.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      HomeScreenContent(onItemTapped: _onItemTapped),
      MyGrievancesScreen(),
      SettingsScreen(),
      FacultyFeedbackScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    exit(0); // Close the app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("GrievEase",
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 28,
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
          elevation: 4,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active, size: 28),
              color: Colors.purple[900],
            ),
          ],
        ),
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: "Grievances"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.purple[900],
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'faculty_feedback.dart';
// import 'grievance_list.dart';
// import 'settings.dart';
// import 'dart:math';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0; // Keep track of selected index
//   late List<Widget> _widgetOptions;
//   @override
//   void initState() {
//     super.initState();
//     _widgetOptions = [
//       HomeScreenContent(onItemTapped: _onItemTapped), // Pass callback
//       MyGrievancesScreen(),
//       SettingsScreen(),
//       FacultyFeedbackScreen(),
//
//     ];
//   }
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color(0xFFF5F5F5),
//     appBar: AppBar(
//       automaticallyImplyLeading: false,
//       title: Text("GrievEase",
//           style: TextStyle(
//               fontFamily: 'Lato',
//               fontSize: 28,
//               fontWeight: FontWeight.w800,
//               color: Colors.purple[900],
//               shadows: const [
//                 Shadow(
//                   blurRadius: 2.0,
//                   color: Color.fromRGBO(0, 0, 0, 0.2),
//                   offset: Offset(1.0, 1.0),
//                 )
//               ]
//           )
//       ),
//       centerTitle: true,
//       elevation: 4,
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.notifications_active, size: 28),
//           color: Colors.purple[900],
//         ),
//       ],
//     ),
//
//
//     body: _widgetOptions[_selectedIndex], // Display selected widget
//
//     bottomNavigationBar: BottomNavigationBar(
//     items: const <BottomNavigationBarItem>[
//     BottomNavigationBarItem(
//     icon: Icon(Icons.home),
//     label: "Home",
//     ),
//     BottomNavigationBarItem(
//     icon: Icon(Icons.upload_file),
//     label: "Grievances",
//     ),
//     BottomNavigationBarItem(
//     icon: Icon(Icons.settings),
//     label: "Settings",
//     ),
//     ],
//     currentIndex: _selectedIndex,
//     selectedItemColor: Colors.purple[900],
//     unselectedItemColor: Colors.grey,
//     onTap: _onItemTapped,
//     ),
//     );
//   }
//
//
// }
//
//

class HomeScreenContent extends StatefulWidget {
  final Function(int) onItemTapped;
  const HomeScreenContent({super.key,required this.onItemTapped});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  late Function(int) _onItemTapped; // Store the callback

  @override
  void initState() {
    super.initState();
    _onItemTapped = widget.onItemTapped; // Assign the callback here
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        offset: Offset(1.0, 1.0),
                      )
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
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
                  _buildActionRow(context, Icons.upload_file, "My Grievances",
                      "View grievances status", 1),
                  _buildActionRow(context, Icons.edit, "Faculty Feedback",
                      "Provide feedback", null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, IconData icon, String title,
      String subtitle, int? index) {
    return InkWell(
      onTap: () {
        if (index != null) { // Navigate using bottom navigation
          _onItemTapped(index);
        } else { // Navigate to a separate FacultyFeedback screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FacultyFeedbackScreen()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}



