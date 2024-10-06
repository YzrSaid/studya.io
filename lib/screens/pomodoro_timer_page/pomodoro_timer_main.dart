import 'package:flutter/material.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/create_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/start_pomodoro_timer/add_timer.dart';

class PomodoroTimerMain extends StatefulWidget {
  const PomodoroTimerMain({super.key});

  @override
  State<PomodoroTimerMain> createState() => _PomodoroTimerMainState();
}

class _PomodoroTimerMainState extends State<PomodoroTimerMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text('study sessions'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(112, 182, 1, 1),
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Spacer(),
              //start button
              Align(
                  alignment: Alignment.bottomRight,
                  child: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                      color: const Color.fromRGBO(250, 249, 246, 1),
                      offset: const Offset(0, -120),
                      icon: const Icon(Icons.add_circle),
                      iconSize: 60,
                      tooltip: 'Add',
                      iconColor: const Color.fromRGBO(112, 182, 1, 1),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              leading: const Icon(Icons.start),
                              title: const Text('Start a Study Session'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddTimer()));
                              },
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              leading: const Icon(Icons.create),
                              title: const Text('Create a Study Session'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateTimer()));
                              },
                            )),
                          ])),
            ],
          ),
        ));
  }
}
