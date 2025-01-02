import 'package:flutter/material.dart';
import 'first.dart'; // Import the FirstPage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF2E481E),
          ),
          // Vector wmremove_tr
          Positioned(
            left: -size.width * 0,  // Responsive left position
            top: 0,
            child: Container(
              width: size.width * 1,  // Responsive width
              height: size.height * 0.65,  // Responsive height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/uiui.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Vector_1
         Positioned(
            left: size.width * 0,  // Responsive left position
            top: size.height * 0.33,  // Responsive top position
            child: Container(
              width: size.width ,  // Responsive width
              height: size.height ,  // Responsive height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/po.png'),  // Use your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // First TextView: "Plant a tree & save our planet"
          Positioned(
            left: size.width * 0.25,  // Responsive left position
            top: size.height * 0.65,  // Responsive top position
            child: Text(
              "Plant a tree & \nsave our planet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.07,  // Responsive font size
                color: Colors.white,
                fontFamily: 'Lexend',
                height: 1.2,  // Line height
              ),
            ),
          ),
          // Second TextView: "Plant a tree and help us to cure our planet"
          Positioned(
            left: size.width * 0.135,  // Responsive left position
            top: size.height * 0.75,  // Responsive top position
            child: Text(
              "Plant a tree and help us to cure our planet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.04,  // Responsive font size
                color: const Color(0xFF91A37F),
                fontFamily: 'Lexend',
                height: 1.25,
              ),
            ),
          ),
       // Rectangle_1 Button Background
          Positioned(
            left: size.width * 0.30,  // Responsive left position
            top: size.height * 0.845,  // Responsive top position
            child: ElevatedButton(
              onPressed: () {
                // Action on button click
                 // Navigate to FirstPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstPage()),
                );
                // Navigate to another page or perform an action here.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF569033),  // Correct button background color
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.07,
                  vertical: size.height * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.black.withOpacity(0.8),
                elevation: 8,
              ),
              child: Text(
                "Plant a tree",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.05,  // Responsive font size
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  height: 1.22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}