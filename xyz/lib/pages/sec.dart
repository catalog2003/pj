import 'package:flutter/material.dart';
import 'package:xyz/pages/third.dart';






class SecPage extends StatelessWidget {
  const SecPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      
      body: Stack(
        children: [

            Positioned(
            top: -size.height * 0.065,
            left: -size.width * 0.4 ,
            child: Image.asset(
              "assets/Ellipse3.png",
              width: size.width * 0.8,
              height: size.width * 0.8,
            ),
            ),
          // Positioned Ellipse 6 Image
          Positioned(
            top: size.height * 0.5,
            left: size.width * -0.2,
            child: Image.asset(
              "assets/Ellipse1.png",
              width: size.width * 0.8,
              height: size.height * 0.8,
            ),
          ),
          // Positioned Main Image
          Positioned(
            top: size.height * -0.2,
            left: size.width * -0.1,
            child: Image.asset(
              "assets/2.png",
              width: size.width * 1.2,
              height: size.height * 1.2,
            ),
          ),
          // Positioned Ellipse 7 Image
          Positioned(
            top: size.height * 0.1,
            left: size.width * 0.6,
            child: Image.asset(
              "assets/Ellipse2.png",
              width: size.width * 0.9,
              height: size.height * 0.9,
            ),
          ),
          // Positioned Ellipse 12 Image
          
          // Positioned Circles
          Positioned(
            top: size.height * 0.64,
            left: (size.width - (size.width * 0.06 + size.width * 0.03)) / 2,
            child: Row(
              children: [
                // Circle 1
                Container(
                  width: size.width * 0.03,
                  height: size.width * 0.03,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                     color: Color(0xFFD9D9D9),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                // Circle 2
                Container(
                  width: size.width * 0.03,
                  height: size.width * 0.03,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                   
                      color: Color(0xFF407BFF),
                  ),
                ),
              ],
            ),
          ),
          // Positioned Welcome Text
          Positioned(
            top: size.height * 0.7,
            left: (size.width - size.width * 0.3) / 2,
            child: Text(
              "Welcome",
              style: TextStyle(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Positioned Description Text
          Positioned(
            top: size.height * 0.76,
            left: (size.width - size.width * 0.8) / 2,
            child: SizedBox(
              width: size.width * 0.8,
              child: Text(
                "Make your home green with our plants",
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Positioned Next Button
       Positioned(
  top: size.height * 0.8,
  left: (size.width - size.width * 0.3) / 2,
  child: SizedBox(
    width: size.width * 0.3,
    height: size.height * 0.06,
    child: ElevatedButton(
      onPressed: () {
                // Action on button click
                 // Navigate to FirstPage
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdPage()),
                );
                // Navigate to another page or perform an action here.
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff16182c), // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.04),
        ),
      ),
      child: Text(
        "Next",
        style: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    ),
  ),
)

        ],
      ),
    );
  }
}
