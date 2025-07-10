import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final url = "http://192.168.1.8:8000/faculty/login"; // Replace with your Django API URL

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _usernameController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data["token"];

      // Save token in Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      // Navigate to home screen
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.purple[900],
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.2),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome To GrievEase',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.purple[900],
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _animation,
                child: Image.asset(
                  'assets/images/loginImg.gif',
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person, color: Colors.purple[300]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple[400]!),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.purple[300]),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple[400]!),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    loginUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4A148C),
                        Color(0xFF7B1FA2),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'home.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin { // For animation
//   final _formKey  = GlobalKey<FormState>();
//
//   // Controllers for text fields
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool _obscureText = true;
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500), // Adjust animation duration
//     );
//     _animation = Tween<Offset>(
//       begin: Offset(0, 1), // Start off-screen (below)
//       end: Offset.zero, // End at original position
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _controller.forward(); // Start the animation
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _usernameController.dispose(); // Dispose controllers
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login',
//         style: TextStyle(
//           fontFamily: 'Lato',
//           fontSize: 28,
//           fontWeight: FontWeight.w800,
//           color: Colors.purple[900],
//           shadows: [
//             Shadow(
//               blurRadius: 2.0,
//               color: Colors.black.withOpacity(0.2),
//               offset: Offset(1.0, 1.0),
//             ),
//           ],
//         ),
//       ),
//         centerTitle: true,),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column( // Outer Column
//             mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
//             children: <Widget>[
//                  Text( // Welcome Text
//                 'Welcome To GrievEase',
//                 style: TextStyle(
//                   fontFamily: 'Lato',
//                   fontSize: 28,
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.w300,
//                   color: Colors.purple[900],
//                 ),
//               ),
//               const SizedBox(height: 20), // Spacing
//               Column( // Inner Column (for the rest of the content)
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SlideTransition(
//                     position: _animation,
//                     child: Image.asset(
//                       'assets/images/loginImg.gif',
//                       height: 200,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   //username Field
//                   TextFormField(
//                     controller: _usernameController,
//                     decoration: InputDecoration(
//                       labelText: 'Username',
//                       labelStyle: TextStyle( // Style the label
//                         color: Colors.grey[600], // Example color
//                       ),
//                       hintText: 'Enter your username', // Add a hint
//                       hintStyle: TextStyle(
//                         color: Colors.grey[400],
//                       ),
//                       prefixIcon: Icon(Icons.person, color: Colors.purple[300]), // Add an icon
//                       focusedBorder: OutlineInputBorder( // Style the focused border
//                         borderSide: BorderSide(color: Colors.purple[400]!), // Example color
//                         borderRadius: BorderRadius.circular(20.0), // Rounded corners
//                       ),
//                       enabledBorder: OutlineInputBorder( // Style the enabled border
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//
//                       // Add a subtle shadow
//                       filled: true,
//                       fillColor: Colors.grey[100],  // Light background color
//                       contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Adjust padding
//
//                       errorBorder: OutlineInputBorder( // Consistent border on error
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder( // Consistent border when focused and has error
//                         borderSide: BorderSide(color: Colors.purple[400]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                     ),
//                     style: TextStyle( // Style the entered text
//                       color: Colors.black, // Example color
//                     ),
//
//                     validator: (value) { // Validator function
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a username';
//                       }
//                       return null; // Return null if the input is valid
//                     },
//                   ),
//                    const SizedBox(height: 20),
//                   //password Field starts
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscureText,  // Hide the password characters
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: TextStyle(
//                         color: Colors.grey[600],
//                       ),
//                       hintText: 'Enter your password',
//                       hintStyle: TextStyle(
//                         color: Colors.grey[400],
//                       ),
//                       prefixIcon: Icon(Icons.lock, color: Colors.purple[300]), // Use a lock icon
//                       suffixIcon: IconButton( // Add a visibility toggle icon
//                         icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.purple[400]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//                       errorBorder: OutlineInputBorder( // Consistent border on error
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder( // Consistent border when focused and has error
//                         borderSide: BorderSide(color: Colors.purple[400]!),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                     ),
//                     style: TextStyle(
//                       color: Colors.black,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field cannot be empty';
//                       }
//                       return null;
//                     },
//
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   ElevatedButton(
//
//                     onPressed: () {
//                       // Handle login logic here (no sliding)
//                       if (_formKey.currentState!.validate()) { // Validate the form
//                         String username = _usernameController.text;
//                         String password = _passwordController.text;
//                         print(username + ' ' + password);
//                         if(username=="aayrin" && password=="Aayrin30@#"){
//                           Navigator.pushNamed(context, '/home');
//                           print("Login Successful");
//                         }else{
//                           ScaffoldMessenger.of(context).showSnackBar(
//                              SnackBar(content: Text('Incorrect Username or Password')),
//                           );
//                         }
//                         }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.zero, // Remove default padding
//                       elevation: 0, // Remove default elevation
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25), // Match the slider's radius
//                       ),
//                     ),
//                     child: Ink( // Use Ink for gradient
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         gradient: const LinearGradient( // Add const
//                           colors: [
//                             Color(0xFF4A148C), // Darker purple (start)
//                             Color(0xFF7B1FA2), // Lighter purple (end)
//                           ],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                         // boxShadow: [
//                         //   BoxShadow(
//                         //     color: Colors.black.withOpacity(0.3),
//                         //     blurRadius: 5,
//                         //     offset: const Offset(0, 3), // Add const
//                         //   ),
//                         // ],
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Add const
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [ // Add const
//                             Text(
//                               'Login', // Or 'Slide to Continue' if you prefer the same text
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }