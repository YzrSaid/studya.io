import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen4 extends StatefulWidget {
  const OnboardingScreen4({super.key});

  @override
  State<OnboardingScreen4> createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Image at the top center
          Padding(
            padding: EdgeInsets.only(top: 80.h),  // Scaled padding
            child: Image.asset(
              'assets/images/onboarding_4.png',
              height: 300.h,  // Scaled height
              width: 300.w,   // Scaled width
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20.h),  // Scaled space
          // Title text
          Text(
            'Let\'s Get Started!',
            style: TextStyle(
              fontSize: 30.sp,  // Scaled font size
              fontFamily: 'Monserrat',
              fontWeight: FontWeight.w900,
              color: const Color.fromRGBO(112, 182, 1, 1),
            ),
          ),
          SizedBox(height: 40.h),  // Scaled space
          // Description text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),  // Scaled padding
            child: Text(
              'Join thousands of students leveling up their study habits. Tap below to start your journey!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,  // Scaled font size
                color: const Color.fromRGBO(62, 62, 62, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
