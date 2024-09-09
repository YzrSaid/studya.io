import 'package:flutter/material.dart';
import 'package:studya_io/add_study_session/timer_add.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('studya'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromRGBO(112, 182, 1, 1),
          fontFamily: 'MuseoModerno',
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Image(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                image: AssetImage('assets/logo.png'),
              ),
            ),

            //start button
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TimerAdd(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(112, 182, 1, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(
                    fontFamily: 'MuseoModerno',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Start a Study Session',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //put the logo in the center of the screen
    );
  }
}

// Method to open the input dialog
void _openInputDialog(BuildContext context) {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Input Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              print(nameController.text);
              print(emailController.text);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
