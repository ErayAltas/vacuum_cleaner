import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vacuum_cleaner/room.dart';
import 'package:vacuum_cleaner/vacuum_cleaner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Room roomA = Room();
  Room roomB = Room();
  VacuumCleaner vacuumCleaner = VacuumCleaner();
  late Timer timer;
  int remainingTime = 120;
  List<String> systemLogs = [];
  TextEditingController systemLogsController = TextEditingController();
  ScrollController textFieldScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    roomA.isDirty = true;
    roomB.isDirty = true;
    startTimer();

    systemLogsController.addListener(() {
      textFieldScrollController.jumpTo(textFieldScrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> cleanRoomA() async {
    systemLogs.add("Vacuum cleaner is cleaning room A");
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    systemLogs.add("Vacuum cleaner finished cleaning room A");
    systemLogsController.text = systemLogs.join("\n");
    roomA.isDirty = false;
    setState(() {});
  }

  Future<void> cleanRoomB() async {
    systemLogs.add("Vacuum cleaner is cleaning room B");
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    systemLogs.add("Vacuum cleaner finished cleaning room B");
    systemLogsController.text = systemLogs.join("\n");
    roomB.isDirty = false;
    setState(() {});
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) {
        cleanRoomA();
        cleanRoomB();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Status : ${roomA.isDirty ? 'Dirty' : 'Clean'}"),
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Status : ${roomB.isDirty ? 'Dirty' : 'Clean'}"),
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      startTimer();
                    },
                    child: const Text("-"),
                  ),
                  const SizedBox(
                    width: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      startTimer();
                    },
                    child: const Text("+"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  startTimer();
                },
                child: const Text("Start"),
              ),
              const SizedBox(height: 20),
              const Text("System logs"),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                constraints: const BoxConstraints(maxHeight: 100),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: systemLogsController,
                    readOnly: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
