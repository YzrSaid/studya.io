import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Image at the top center
          Padding(
            padding: EdgeInsets.only(top: 50.h), // Scaled padding
            child: Image.asset(
              'assets/images/logo.png',
              height: 300.h,
              width: 300.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20.h),
          // Title text
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 30.sp, // Scaled font size
              fontFamily: 'Monserrat',
              fontWeight: FontWeight.w900,
              color: const Color.fromRGBO(112, 182, 1, 1),
            ),
          ),
          SizedBox(height: 40.h),
          // Description text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w), // Scaled padding
            child: Text(
              'Your ultimate study companion to stay focused, productive, and organized.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: const Color.fromRGBO(62, 62, 62, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
