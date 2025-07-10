
import 'package:flutter/material.dart';
import 'manage_profile.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Text("Settings Screen",
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
                ])
              ,),
        centerTitle:true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Manage Profile",style: TextStyle(fontSize: 18),),
                IconButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>ManageProfile()
                      )
                  );
                }, icon: Icon(Icons.arrow_forward))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Terms and conditions",style: TextStyle(fontSize: 18),),
                IconButton(onPressed: (){
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context)=>RequestReview()
                  //     )
                  // );
                }, icon: Icon(Icons.arrow_forward))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("FAQ",style: TextStyle(fontSize: 18),),
                IconButton(onPressed: (){
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context)=>RequestReview()
                  //     )
                  // );
                }, icon: Icon(Icons.arrow_forward))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Help?",style: TextStyle(fontSize: 18),),
                IconButton(onPressed: (){
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context)=>RequestReview()
                  //     )
                  // );
                }, icon: Icon(Icons.arrow_forward))
              ],
            ),
          ),
        ],
      )
    );
  }
}

