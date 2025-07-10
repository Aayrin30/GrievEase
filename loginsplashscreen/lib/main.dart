import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grievance Redressal',
      home: const SplashScreen(), // Always start with splash screen
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'splash_screen.dart'; // Import your splash screen
// import 'login_screen.dart';
// import 'home.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString("token"); // Retrieve saved token
//
//   runApp(MyApp(initialRoute: token == null ? '/login' : '/home'));
// }
//
// class MyApp extends StatelessWidget {
//   final String initialRoute;
//   MyApp({required this.initialRoute});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Grievance Redressal',
//       home: SplashScreen(), // Show splash screen first
//       routes: {
//         '/login': (context) => LoginScreen(),
//         '/home': (context) => HomePage(),
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'splash_screen.dart';// Import your splash screen
// import 'login_screen.dart';
// import 'home.dart';
// // import 'demo.dart';
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Grievance Redressal',
//       home: SplashScreen(), // Set the splash screen as the initial route
//       routes: {
//         '/login': (context) => LoginScreen(), // Login route
//         '/home': (context) => HomePage(),
//       },
//     );
//   }
// }