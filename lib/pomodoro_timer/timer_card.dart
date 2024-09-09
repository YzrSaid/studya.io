import 'package:flutter/material.dart';

class TimerCard extends StatelessWidget {
  final int minutes;
  final int seconds;

  const TimerCard({super.key, required this.minutes, required this.seconds});

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutesStr = twoDigits(minutes);
    final secondsStr = twoDigits(seconds);

    double hoursfontSize = 70;
    double secondsFontSize = 70;
    if (minutesStr.length > 2) {
      hoursfontSize = 55;
      secondsFontSize = 55;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(195, 193, 193, 0.5),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                // ignore: unnecessary_string_interpolations
                '$minutesStr',
                style: TextStyle(
                  color: const Color.fromRGBO(112, 182, 1, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: hoursfontSize,
                ),
              )),
            ),
            const SizedBox(width: 10),
            const Text(':',
                style: TextStyle(
                  color: Color.fromRGBO(195, 193, 193, 1),
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )),
            const SizedBox(width: 10),
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(195, 193, 193, 0.5),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                // ignore: unnecessary_string_interpolations
                '$secondsStr',
                style: TextStyle(
                  color: const Color.fromRGBO(112, 182, 1, 1),
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
