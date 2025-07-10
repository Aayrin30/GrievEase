import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _slideComplete = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    await Future.delayed(const Duration(seconds: 2)); // Ensure splash screen shows for a bit

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8),
                    BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 50, 0, 0),
                  child: Image.asset("assets/images/welcome.gif", fit: BoxFit.contain),
                ),
                const SizedBox(height: 5),
                Text(
                  'GrievEase',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 37,
                    fontWeight: FontWeight.w900,
                    color: Colors.purple[900],
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '"Turning Concerns Into Solutions"',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: Colors.purple[900],
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildSlideButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        return _slideComplete
            ? Container()
            : Dismissible(
          key: const Key('slideButton'),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              setState(() => _slideComplete = true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  LoginScreen()),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.purple[900]!,
                  Colors.purple[400]!,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_forward_ios, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Slide to Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// // import 'animated_logo.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   bool _slideComplete = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack( // Use a Stack to overlay content on the image
//         children: [
//           FractionallySizedBox( // Image takes half the screen
//             heightFactor: 0.5,
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/background.png'),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     Colors.white.withOpacity(0.8), // Adjust opacity here (0.0 - 1.0)
//                     BlendMode.modulate, // Use BlendMode.modulate for opacity
//                   ),// Or BoxFit.contain, BoxFit.fill
//                 ),
//               ),
//             ),
//           ),
//           Center( // Content is centered on the remaining space
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 // AnimatedGrievEaseLogo(),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(50, 50, 0, 0),
//                     child: Image.asset("assets/images/welcome.gif",
//                       fit: BoxFit.contain,),
//                   ),
//                 ),
//
//                 SizedBox(height: 5),
//                 Text(
//                   'GrievEase',
//                   style: TextStyle(
//                     fontFamily: 'Montserrat', // Or another bold font
//                     fontSize: 37,
//                     fontWeight: FontWeight.w900, // Extra bold
//                     color: Colors.purple[900], // Or a contrasting color
//                     shadows: [
//                       Shadow(
//                         blurRadius: 5.0,
//                         color: Colors.black.withOpacity(0.3),
//                         offset: Offset(2.0, 2.0),
//                       ),
//                     ],
//
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   '"Turning Concerns Into Solutions"',
//                   style: TextStyle(
//                     fontFamily: 'Lato',
//                     fontSize: 24,
//                     fontStyle: FontStyle.italic,
//                     fontWeight: FontWeight.w300,
//                     color: Colors.purple[900],
//                     shadows: [
//                       Shadow(
//                         blurRadius: 2.0,
//                         color: Colors.black.withOpacity(0.2),
//                         offset: Offset(1.0, 1.0),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 _buildSlideButton(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSlideButton() {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return _slideComplete
//             ? Container()
//             : Dismissible(
//           key: Key('slideButton'),
//           direction: DismissDirection.startToEnd,
//           onDismissed: (direction) {
//             if (direction == DismissDirection.startToEnd) {
//               setState(() {
//                 _slideComplete = true;
//               });
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//               );
//             }
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               gradient: LinearGradient( // Gradient background
//                 colors: [
//                   Colors.purple[900]!, // Start color (adjust shade)
//                   Colors.purple[400]!, // End color (adjust shade)
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               boxShadow: [ // Add a subtle shadow
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.arrow_forward_ios, color: Colors.white), // White icon
//                 SizedBox(width: 10),
//                 Text(
//                   'Slide to Continue',
//                   style: TextStyle(color: Colors.white), // White text
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }