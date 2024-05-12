import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo Leveling Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Solo Leveling Tracker Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class Exercise {
  String name;
  bool isDone;

  Exercise({required this.name, this.isDone = false});
}

class MyHomePageState extends State<MyHomePage> {
  final List<Exercise> exercises = [
    Exercise(name: '100 Push Ups'),
    Exercise(name: '100 Sit Ups'),
    Exercise(name: '100 Squats'),
    Exercise(name: '10 km Run'),
  ];

  void toggleDone(Exercise exercise) {
    setState(() {
      exercise.isDone = !exercise.isDone;
    });
  }

  void saveExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final doneExercises = exercises.where((e) => e.isDone).map((e) => e.name).toList();
    prefs.setStringList('doneExercises', doneExercises);
  }

  void loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final doneExercises = prefs.getStringList('doneExercises') ?? [];
    for (var exercise in exercises) {
      exercise.isDone = doneExercises.contains(exercise.name);
    }
  }

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text(exercise.name),
            trailing: Checkbox(
              value: exercise.isDone,
              onChanged: (bool? value) {
                toggleDone(exercise);
                saveExercises();
              },
            ),
          );
        },
      ),
    );
  }
}