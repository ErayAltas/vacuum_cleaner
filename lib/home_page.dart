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
    initValues();
  }

  void initValues() {
    roomA.isDirty = true;
    roomB.isDirty = true;
    totalSystemTime = 60;
    systemLogs.clear();
    systemLogsController.clear();
    setState(() {});
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
    initValues();
    systemLogs.add("system is started");
    systemLogsController.text = systemLogs.join("\n");
    systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
    startCleaningTimer();
    systemTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          totalSystemTime--;
        });
        if (totalSystemTime == 0) {
          systemLogs.add("system is shutting down");
          systemLogsController.text = systemLogs.join("\n");
          systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
          cancelTimers();
        }
      },
    );
  }

  void startCleaningTimer() {
    decideWhichRoom();
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
    systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
    if (roomA.isDirty) {
      cleanRoomA();
    } else if (roomB.isDirty) {
      cleanRoomB();
    } else {
      systemLogs.add("Both rooms are clean");
      systemLogsController.text = systemLogs.join("\n");
      systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
    }
  }

  Future<void> cleanRoomA() async {
    systemLogs.add("Vacuum cleaner is cleaning room A");
    systemLogsController.text = systemLogs.join("\n");
    systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    systemLogs.add("Vacuum cleaner finished cleaning room A");
    systemLogsController.text = systemLogs.join("\n");
    systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
    roomA.isDirty = false;
    setState(() {});
    startRoomATimer();
  }

  Future<void> cleanRoomB() async {
    systemLogs.add("Vacuum cleaner is cleaning room B");
    systemLogsController.text = systemLogs.join("\n");
    systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    systemLogs.add("Vacuum cleaner finished cleaning room B");
    systemLogsController.text = systemLogs.join("\n");
    systemLogsController.selection = TextSelection.fromPosition(TextPosition(offset: systemLogsController.text.length));
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
              const SizedBox(height: 20),
              Text("System time : $totalSystemTime", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20)),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Center(
                        child: Text(
                          roomA.isDirty ? 'Dirty' : 'Clean',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.red),
                      child: Center(
                          child: Text(
                        roomB.isDirty ? 'Dirty' : 'Clean',
                        style: Theme.of(context).textTheme.headlineLarge,
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: const ButtonStyle(minimumSize: MaterialStatePropertyAll(Size(300, 45))),
                onPressed: () {
                  startSystem();
                },
                child: const Text("Start"),
              ),
              const SizedBox(height: 40),
              const Text("System logs", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                constraints: const BoxConstraints(maxHeight: 200, minHeight: 200),
                child: TextField(
                  scrollController: textFieldScrollController,
                  controller: systemLogsController,
                  readOnly: true,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  maxLines: null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
