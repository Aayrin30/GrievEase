import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'login_screen.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({super.key});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  // ✅ Logout Function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token"); // Remove stored token

    // Navigate to login screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // This clears all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/profile1.jpg',
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Image.asset(
                  'assets/images/profile1.jpg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Allison',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(width: 20),
                const Text('alisonw2043@gmail.com',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 20),
                const Text('+1415-123-4567', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.bookmark_add_outlined),
                const SizedBox(width: 20),
                const Text('Engineering', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 20),
                const Text('Joined on Nov 4, 2023', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile page
                },
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to change password page
                },
                child: const Text('Change Password'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logout, // Calls the logout function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[900],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// class ManageProfile extends StatefulWidget {
//   const ManageProfile({super.key});
//
//   @override
//   State<ManageProfile> createState() => _ManageProfileState();
// }
//
// class _ManageProfileState extends State<ManageProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile",style: TextStyle(fontWeight: FontWeight.bold),),
//         centerTitle:true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center( // Center the image
//               child: Image.asset(
//                 'assets/images/profile1.jpg', // Replace with your image path
//                 width: double.infinity, // Adjust size as needed
//                 height: 160,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Image.asset('assets/images/profile1.jpg',
//                   width: 40,
//                   height: 40,
//                 ),
//                 SizedBox(width: 10,),
//                 Text(
//                   'Allison',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 Icon(Icons.email),
//                 SizedBox(width: 20,),
//                 Text('alisonw2043@gmail.com',style: TextStyle(fontSize: 16),),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.phone),
//                 SizedBox(width: 20,),
//                 Text('+1415-123-4567',style: TextStyle(fontSize: 16),),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//             children: [
//             Icon(Icons.bookmark_add_outlined),
//             SizedBox(width: 20,),
//             Text('Engineering',style: TextStyle(fontSize: 16),),
//             ],
//             ),
//             SizedBox(height: 8),
//             Row(
//             children: [
//             Icon(Icons.date_range),
//             SizedBox(width: 20,),
//             Text('Joined on Nov 4. 2023',style: TextStyle(fontSize: 16),),
//             ],
//             ),
//             SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Navigate to edit profile page
//                 },
//                 child: const Text('Edit Profile'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () {
//                   // Navigate to change password page
//                 },
//                 child: const Text('Change Password'),
//               ),
//             ),
//             SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context)=> LoginScreen()
//                       ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple[900],
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text('Log Out'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
