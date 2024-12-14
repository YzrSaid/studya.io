import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer.dart';

class TimerCard extends StatefulWidget {
  final int minutes;
  final int seconds;
  final TimerState currentState;

  const TimerCard(
      {super.key,
      required this.minutes,
      required this.seconds,
      required this.currentState});

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutesStr = twoDigits(widget.minutes);
    final secondsStr = twoDigits(widget.seconds);

    double hoursfontSize = 60.sp;
    double secondsFontSize = 60.sp;
    if (minutesStr.length > 2) {
      hoursfontSize = 55;
      secondsFontSize = 55;
    }

    // Use widget.currentState instead of local currentState
    TimerState currentState = widget.currentState;

    Color timerColor;

    switch (currentState) {
      case TimerState.pomodoro:
        timerColor = const Color.fromRGBO(112, 182, 1, 1);
        break;
      case TimerState.shortbreak:
        timerColor = const Color.fromRGBO(62, 62, 62, 1);
        break;
      case TimerState.longbreak:
        timerColor = const Color.fromARGB(255, 0, 0, 0);
        break;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                color: const Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Color.fromRGBO(195, 193, 193, 0.5),
                //     offset: Offset(0, 2),
                //     blurRadius: 4,
                //     spreadRadius: 4,
                //   ),
                // ],
              ),
              child: Center(
                  child: Text(
                // ignore: unnecessary_string_interpolations
                '$minutesStr',
                style: TextStyle(
                  color: timerColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: hoursfontSize,
                ),
              )),
            ),
            20.horizontalSpace,
            Text(':',
                style: TextStyle(
                  color: Color.fromRGBO(195, 193, 193, 1),
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
                  fontSize: 50.sp,
                )),
            20.horizontalSpace,
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                color: const Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Color.fromRGBO(195, 193, 193, 0.5),
                //     offset: Offset(0, 2),
                //     blurRadius: 4,
                //     spreadRadius: 4,
                //   ),
                // ],
              ),
              child: Center(
                  child: Text(
                // ignore: unnecessary_string_interpolations
                '$secondsStr',
                style: TextStyle(
                  color: timerColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: secondsFontSize,
                ),
              )),
            ),
          ],
        )
      ],
    );
  }
}
