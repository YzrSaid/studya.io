import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/boxes.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/create_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/edit_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer.dart';
import 'package:studya_io/screens/pomodoro_timer_page/start_pomodoro_timer/add_timer.dart';

class PomodoroTimerMain extends StatelessWidget {
  const PomodoroTimerMain({super.key});

  @override
  Widget build(BuildContext context) {
    bool isThisASavedTimer = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'study sessions',
          textScaleFactor: 1,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 23.sp,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                color: const Color.fromRGBO(238, 238, 238, 1.0),
                icon: const Icon(Icons.add_circle),
                iconSize: 30,
                tooltip: 'Add',
                iconColor: const Color.fromRGBO(112, 182, 1, 1),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'Start a session',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddTimer()),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'Create a session',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateTimer()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ValueListenableBuilder<Box<HiveModel>>(
                valueListenable: Boxes.getStudSession().listenable(),
                builder: (context, box, index) {
                  final studSessions = box.values.toList().cast<HiveModel>();
                  if (box.isEmpty) {
                    return Center(
                      child: Text(
                        "No sessions created.",
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: studSessions.length,
                    itemBuilder: (context, index) {
                      final studSession = studSessions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 118,
                          width: 150.w,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Color.fromRGBO(250, 249, 246, 1),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                                child: Text(
                                  studSession.studSessionName,
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 94, 1),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                                child: Text(
                                  studSession.selectedStudSession,
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 94, 1),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.5.sp,
                                  ),
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                      elevation: 1,
                                      color: const Color.fromRGBO(
                                          238, 238, 238, 1.0),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.edit,
                                              size: 18.5,
                                            ),
                                            title: Text(
                                              'Edit session',
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                fontSize: 12.5.sp,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                            onTap: () {
                                              editStudSession(
                                                  context, studSession, index);
                                            },
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.delete,
                                              size: 18.5,
                                            ),
                                            title: Text(
                                              'Delete session',
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                fontSize: 12.5.sp,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext dialogContext) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    title: const Text(
                                                      'Delete?',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            84, 84, 84, 1),
                                                        fontSize: 20,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    content: const SizedBox(
                                                      width: 280.0,
                                                      height: 50.0,
                                                      child: Text(
                                                        'Once deleted, this action cannot be undone.',
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              84, 84, 84, 1),
                                                          fontSize: 15,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(dialogContext)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                84, 84, 94, 1),
                                                            fontSize: 15,
                                                            fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          box.deleteAt(index);
                                                          Navigator.of(dialogContext)
                                                              .pop();
                                                          AwesomeDialog(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(bottom: 10),
                                                            bodyHeaderDistance: 30,
                                                            width: 400,
                                                            buttonsBorderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                            context: context,
                                                            headerAnimationLoop:
                                                            false,
                                                            dialogType:
                                                            DialogType.noHeader,
                                                            animType:
                                                            AnimType.bottomSlide,
                                                            title: 'Success',
                                                            titleTextStyle: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 0.803921568627451),
                                                              fontSize: 20,
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            desc:
                                                            'The session has been deleted successfully!',
                                                            descTextStyle:
                                                            const TextStyle(
                                                              color: Color.fromRGBO(
                                                                  81, 81, 81, 1),
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14,
                                                            ),
                                                            btnOkOnPress: () {},
                                                            btnOkColor: Color.fromRGBO(
                                                                112, 182, 1, 1),
                                                            btnOkText: 'Okay',
                                                            customHeader: Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(50),
                                                                color: Color.fromRGBO(
                                                                    112, 182, 1, 1),
                                                              ),
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                              child: const Icon(
                                                                Icons.check,
                                                                size: 50,
                                                                color:
                                                                Colors.white,
                                                              ),
                                                            ),
                                                          ).show();
                                                        },
                                                        style: TextButton.styleFrom(
                                                          backgroundColor:
                                                          Color.fromRGBO(
                                                              112, 182, 1, 1),
                                                          foregroundColor:
                                                          Colors.white,
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 26,
                                                            vertical: 10.0,
                                                          ),
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8.0),
                                                          ),
                                                          elevation: 0,
                                                        ),
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily: 'Montserrat',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                String selectedStudSession =
                                    studSession.selectedStudSession;
                                List<String> timeParts =
                                selectedStudSession.split(" - ");
                                int pomodoroMinutes = int.parse(
                                    timeParts[0].replaceAll(' min', ''));
                                int shortBreakMinutes = int.parse(
                                    timeParts[1].replaceAll(' min', ''));
                                int longBreakMinutes = int.parse(
                                    timeParts[2].replaceAll(' min', ''));

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PomodoroTimer(
                                      pomodoroMinutes: pomodoroMinutes,
                                      shortbreakMinutes: shortBreakMinutes,
                                      longbreakMinutes: longBreakMinutes,
                                      alarmSound: studSession.alarmSound,
                                      isAutoStart:
                                      studSession.isAutoStartSwitched,
                                      sessionKey: studSession.key,
                                      isThisASavedTimer: isThisASavedTimer,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
