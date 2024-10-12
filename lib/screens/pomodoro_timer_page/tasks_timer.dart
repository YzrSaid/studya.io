// ignore_for_file: unused_element
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:studya_io/custom_timer_icons_icons.dart';
import 'package:studya_io/screens/pomodoro_timer_page/pomodoro_timer.dart';

class TasksTimer extends StatefulWidget {
  final TimerState currentState;
  const TasksTimer({super.key, required this.currentState});

  @override
  State<TasksTimer> createState() => _TasksTimerState();
}

class _TasksTimerState extends State<TasksTimer> {
  final List<String> _tasks = [];
  final List<bool> _isTaskDone = []; // Track task completion
  final List<int> _originalIndices = []; // To store original indices of tasks
  int _tasksCount = 0;

  @override
  Widget build(BuildContext context) {
    // Use widget.currentState instead of local currentState
    TimerState currentState = widget.currentState;

    //this is for the colors of the widgets when currentState changes
    Color timerTitleColor;
    Color taskCountColor;
    Color addTaskButtonColor;
    Color taskLineColor;
    Color deleteIconColor;

    switch (currentState) {
      case TimerState.pomodoro:
        timerTitleColor = const Color.fromRGBO(120, 201, 1, 1);
        taskCountColor = const Color.fromRGBO(120, 201, 1, 1);
        addTaskButtonColor = const Color.fromRGBO(120, 201, 1, 1);
        taskLineColor = const Color.fromRGBO(120, 201, 1, 1);
        deleteIconColor = const Color.fromRGBO(81, 81, 81, 1);
        break;
      case TimerState.shortbreak:
        timerTitleColor = const Color.fromRGBO(61, 61, 61, 1);
        taskCountColor = const Color.fromRGBO(61, 61, 61, 1);
        addTaskButtonColor = const Color.fromRGBO(61, 61, 61, 1);
        taskLineColor = const Color.fromRGBO(61, 61, 61, 1);
        deleteIconColor = const Color.fromRGBO(81, 81, 81, 1);
        break;
      case TimerState.longbreak:
        timerTitleColor = const Color.fromARGB(255, 0, 0, 0);
        taskCountColor = const Color.fromARGB(255, 0, 0, 0);
        addTaskButtonColor = const Color.fromARGB(255, 0, 0, 0);
        taskLineColor = const Color.fromARGB(255, 0, 0, 0);
        deleteIconColor = const Color.fromRGBO(81, 81, 81, 1);
        break;
    }
    return Container(
      height: 310,
      width: 325,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 4, 15, 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: taskLineColor,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Tasks',
                    style: TextStyle(
                      color: timerTitleColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _tasksCount.toString(),
                    style: TextStyle(
                      color: taskCountColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 36,
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: () => {
                        _showAddTaskDialog(),
                      },
                      icon: Icon(CustomTimerIcons.plus,
                          size: 21, color: addTaskButtonColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.5, horizontal: 15),
                  child: Opacity(
                    opacity: _isTaskDone[index] ? 0.8 : 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isTaskDone[index]
                            ? const Color.fromRGBO(81, 81, 81, 0.3)
                            : const Color.fromRGBO(248, 248, 248, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _isTaskDone[index],
                                  onChanged: (bool? value) {
                                    _toggleTaskCompletion(index);
                                  },
                                  fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return const Color.fromRGBO(
                                            81, 81, 81, 0.5);
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                ),
                                // Task Text
                                Text(
                                  _tasks[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isTaskDone[index]
                                        ? Colors.white
                                        : const Color.fromRGBO(81, 81, 81, 1),
                                    decoration: _isTaskDone[index]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: _isTaskDone[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _deleteTask(index),
                                  icon: Icon(Icons.delete,
                                      color: deleteIconColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Move your methods inside the _TasksTimerState class

  void _editTask(int index) {
    TextEditingController editController = TextEditingController();
    editController.text = _tasks[index]; // Set current task text in the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _tasks[index] = editController.text; // Update the task
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      if (!_isTaskDone[index]) {
        _tasksCount--;
      }
      _isTaskDone.removeAt(index);
      _originalIndices.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _isTaskDone[index] = !_isTaskDone[index];
      if (_isTaskDone[index]) {
        // Move the checked task to the bottom of the list
        _moveTaskToBottom(index);
        _tasksCount--;
      } else {
        // Move the unchecked task back to its appropriate position
        moveTaskToTop(index);
        _tasksCount++;
      }
    });
  }

  void _moveTaskToBottom(int index) {
    setState(() {
      String task = _tasks.removeAt(index);
      bool taskStatus = _isTaskDone.removeAt(index);
      _tasks.add(task);
      _isTaskDone.add(taskStatus);
    });
  }

  void moveTaskToTop(int taskIndex) {
    setState(() {
      if (_isTaskDone[taskIndex]) {
        // If task is checked, move it to the bottom (end of the list)
        String completedTask = _tasks.removeAt(taskIndex);
        bool completedTaskStatus = _isTaskDone.removeAt(taskIndex);
        int originalIndex = _originalIndices.removeAt(taskIndex);

        _tasks.add(completedTask);
        _isTaskDone.add(completedTaskStatus);
        _originalIndices.add(originalIndex);
      } else {
        // If task is unchecked, move it back to its top position
        String task = _tasks.removeAt(taskIndex);
        bool taskStatus = _isTaskDone.removeAt(taskIndex);
        int originalIndex = _originalIndices.removeAt(taskIndex);

        // Insert the unchecked task at the beginning (before checked tasks)
        int insertIndex = _isTaskDone.indexWhere((isDone) => isDone == true);
        if (insertIndex == -1) {
          // No checked tasks, insert at the beginning
          insertIndex = 0;
        }

        _tasks.insert(insertIndex, task);
        _isTaskDone.insert(insertIndex, taskStatus);
        _originalIndices.insert(insertIndex, originalIndex);
      }
    });
  }

  Future<void> _showAddTaskDialog() async {
    String newTask = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Close the dialog by tapping outside
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 325, // Set your desired width here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Add a Task',
                    style: TextStyle(
                      color: Color.fromRGBO(81, 81, 81, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey), // Color when not focused
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(
                                81, 81, 81, 1)), // Color when focused
                      ),
                    ),
                    maxLength: 25,
                    autofocus: true,
                    onChanged: (value) {
                      newTask = value; // Capture input value
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text('Cancel',
                            style: TextStyle(
                              color: Color.fromRGBO(81, 81, 81, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (newTask.isNotEmpty) {
                              if (_tasks.contains(newTask)) {
                                Navigator.of(context)
                                    .pop(); // Close input dialog
                                _showErrorDialog(); // Task already exists
                              } else {
                                // Find first checked task
                                int insertIndex = -1;
                                for (int i = 0; i < _tasks.length; i++) {
                                  if (_isTaskDone[i]) {
                                    insertIndex = i;
                                    break;
                                  }
                                }

                                if (insertIndex == -1) {
                                  // No checked tasks, add to the end
                                  _tasks.add(newTask);
                                  _isTaskDone.add(false);
                                  _originalIndices.add(_tasks.length - 1);
                                } else {
                                  // Insert before the first checked task
                                  _tasks.insert(insertIndex, newTask);
                                  _isTaskDone.insert(insertIndex, false);
                                  _originalIndices.insert(
                                      insertIndex, _tasks.length - 1);
                                }
                                _tasksCount++;
                                Navigator.of(context)
                                    .pop(); // Close the input dialog
                                _showSuccessDialog(); // Show success dialog
                              }
                            }
                          });
                        },
                        child: const Text('Save',
                            style: TextStyle(
                              color: Color.fromRGBO(120, 201, 1, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog() {
    AwesomeDialog(
      width: 400,
      buttonsBorderRadius: BorderRadius.circular(10),
      context: context,
      dialogType: DialogType.noHeader, // Keep the error dialog type
      animType: AnimType.bottomSlide,
      title: 'Error',
      titleTextStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      desc: 'Task already exists in the list!',
      descTextStyle: const TextStyle(
        color: Color.fromRGBO(81, 81, 81, 1),
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
      btnOkOnPress: () {},
      btnOkColor: const Color.fromRGBO(120, 201, 1, 0.5),
      btnOkText: 'Okay',
    ).show();
  }

  void _showSuccessDialog() {
    // Lets use switch 
    AwesomeDialog(
      width: 405,
      buttonsBorderRadius: BorderRadius.circular(10),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      title: 'Success',
      titleTextStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      desc: 'Task added successfully!',
      descTextStyle: const TextStyle(
        color: Color.fromRGBO(81, 81, 81, 1),
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
      btnOkOnPress: () {},
      btnOkColor: const Color.fromRGBO(120, 201, 1, 0.5),
      btnOkText: 'Okay',
    ).show();
  }

  void _moveTaskBackToOriginalPosition(int originalIndex) {
    setState(() {
      int currentPosition = _originalIndices.indexOf(originalIndex);
      String task = _tasks.removeAt(currentPosition);
      bool taskStatus = _isTaskDone.removeAt(currentPosition);
      _originalIndices.removeAt(currentPosition);

      _tasks.insert(originalIndex, task);
      _isTaskDone.insert(originalIndex, taskStatus);
      _originalIndices.insert(originalIndex, originalIndex);
    });
  }
}
