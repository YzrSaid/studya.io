import 'package:flutter/material.dart';

class TimerSettings extends StatefulWidget {
  const TimerSettings({super.key});

  @override
  State<TimerSettings> createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: PopupMenuButton(
        elevation: 5,
        shadowColor: const Color.fromRGBO(84, 84, 84, 1),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: ListTile(
              title: const Text('Alarm'),
              leading: const Icon(Icons.alarm),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alarm'),
                        content: const Text('Alarm settings'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: const Text('Auto Start'),
              leading: const Icon(Icons.replay),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alarm'),
                        content: const Text('Alarm settings'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: const Text('Notifications'),
              leading: const Icon(Icons.notifications),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alarm'),
                        content: const Text('Alarm settings'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          const PopupMenuItem(
            child: ListTile(
              title: Text('Skip to break'),
              leading: Icon(Icons.fast_forward_rounded),
            ),
          ),
          const PopupMenuItem(
            child: ListTile(
              title: Text('Skip to long break'),
              leading: Icon(Icons.fast_forward_rounded),
            ),
          ),
        ],
        icon: const Icon(
          Icons.settings,
          color: Color.fromRGBO(84, 84, 84, 0.5),
          size: 30,
        ),
      ),
    );
  }
}
