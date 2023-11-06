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
  late Timer roomATimer;
  late Timer roombTimer;
  late Timer systemTimer;
  late Timer cleaningTimer;
  int totalSystemTime = 60;
  List<String> systemLogs = [];
  TextEditingController systemLogsController = TextEditingController();
  ScrollController textFieldScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    roomA.isDirty = true;
    roomB.isDirty = true;
    systemLogsController.addListener(() {
      setState(() {
        textFieldScrollController.jumpTo(textFieldScrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    cancelTimers();
    super.dispose();
  }

  void cancelTimers() {
    systemTimer.cancel();
    roomATimer.cancel();
    roombTimer.cancel();
    cleaningTimer.cancel();
  }

  void startSystem() {
    systemLogs.add("system is starting");
    systemLogsController.text = systemLogs.join("\n");
    startCleaningTimer();
    systemTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          totalSystemTime--;
        });
        if (totalSystemTime == 0) {
          cancelTimers();
          systemLogs.add("system is shutting down");
          systemLogsController.text = systemLogs.join("\n");
        }
      },
    );
  }

  void startCleaningTimer() {
    cleaningTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) {
        decideWhichRoom();
      },
    );
  }

  void decideWhichRoom() {
    systemLogs.add("Vacuum cleaner controlling room A and room B");
    systemLogsController.text = systemLogs.join("\n");
    if (roomA.isDirty) {
      cleanRoomA();
    } else if (roomB.isDirty) {
      cleanRoomB();
    } else {
      systemLogs.add("Both rooms are clean");
      systemLogsController.text = systemLogs.join("\n");
    }
  }

  Future<void> cleanRoomA() async {
    systemLogs.add("Vacuum cleaner is cleaning room A");
    systemLogsController.text = systemLogs.join("\n");
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    systemLogs.add("Vacuum cleaner finished cleaning room A");
    systemLogsController.text = systemLogs.join("\n");
    roomA.isDirty = false;
    setState(() {});
    startRoomATimer();
  }

  Future<void> cleanRoomB() async {
    systemLogs.add("Vacuum cleaner is cleaning room B");
    systemLogsController.text = systemLogs.join("\n");
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    systemLogs.add("Vacuum cleaner finished cleaning room B");
    systemLogsController.text = systemLogs.join("\n");
    roomB.isDirty = false;
    setState(() {});
    startRoomBTimer();
  }

  void startRoomATimer() {
    roomATimer = Timer.periodic(
      const Duration(seconds: 20),
      (Timer timer) {
        setState(() {
          roomA.isDirty = true;
        });
      },
    );
  }

  void startRoomBTimer() {
    roombTimer = Timer.periodic(
      const Duration(seconds: 20),
      (Timer timer) {
        setState(() {
          roomB.isDirty = true;
        });
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
              const SizedBox(height: 20),
              Text("System time : $totalSystemTime"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  startSystem();
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
                    scrollController: textFieldScrollController,
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
