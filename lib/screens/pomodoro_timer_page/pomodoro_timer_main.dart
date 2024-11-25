import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/boxes.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/create_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/edit_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';
import 'package:studya_io/screens/pomodoro_timer_page/start_pomodoro_timer/add_timer.dart';

class PomodoroTimerMain extends StatelessWidget {
  const PomodoroTimerMain({super.key});

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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ValueListenableBuilder<Box<HiveModel>>(
              valueListenable: Boxes.getStudSession().listenable(),
              builder: (context, box, index) {
                final studSessions = box.values.toList().cast<HiveModel>();
                return Expanded(
                  child: ListView.builder(
                    itemCount: studSessions.length,
                    itemBuilder: (context, index) {
                      final studSession = studSessions[index];
                      return Card(
                        color: const Color.fromRGBO(250, 249, 246, 1),
                        child: ListTile(
                          title: Text(
                            studSession.studSessionName,
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            studSession.selectedStudSession,
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Pass the Hive key to the edit function
                                  editStudSession(context, studSession, index);
                                },
                              ),
                              // Delete button
                              IconButton(
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  box.deleteAt(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Add button
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
                                      builder: (context) => const AddTimer()));
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
      ),
    );
  }

  void editStudSession(
      BuildContext context, HiveModel studSession, int session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTimer(
          editStudSessionName: studSession.studSessionName,
          editSelectedStudSession: studSession.selectedStudSession,
          editAlarmSound: studSession.alarmSound,
          editIsAutoStartSwitched: studSession.isAutoStartSwitched,
          sessionKey: studSession.key,
        ),
      ),
    );
  }
}
