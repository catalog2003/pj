import 'package:flutter/material.dart';

class SecPage extends StatelessWidget {
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
              "assets/Ellipse 12.png",
              width: size.width * 0.8,
              height: size.width * 0.8,
            ),
            ),
          // Positioned Ellipse 6 Image
          Positioned(
            top: size.height * 0.5,
            left: size.width * -0.2,
            child: Image.asset(
              "assets/Ellipse 6.png",
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
              "assets/Ellipse 7.png",
              width: size.width * 0.9,
              height: size.height * 0.9,
            ),
          ),
          // Positioned Ellipse 12 Image
          
          // Positioned Circles
          Positioned(
            top: size.height * 0.64,
            left: size.width * 0.5,
            child: Row(
              children: [
                // Circle 1
                Container(
                  width: size.width * 0.03,
                  height: size.width * 0.03,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                     color: Color(0xFFD9D9D9),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                // Circle 2
                Container(
                  width: size.width * 0.03,
                  height: size.width * 0.03,
                  decoration: BoxDecoration(
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
            left: size.width * 0.35,
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
            left: size.width * 0.1,
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
  left: size.width * 0.38,
  child: SizedBox(
    width: size.width * 0.3,
    height: size.height * 0.06,
    child: ElevatedButton(
      onPressed: () {
        // Handle "Next" button press
        print("Next button pressed");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff16182c), // Button background color
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
