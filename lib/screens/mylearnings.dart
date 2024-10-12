import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/data/course_data.dart';
import 'package:e_learning_app/drawer/mydrawer.dart';
import 'package:e_learning_app/model/programming_course.dart';
import 'package:e_learning_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';


class Mylearnings extends StatefulWidget {
  const Mylearnings({super.key});

  @override
  State<Mylearnings> createState() => _MylearningsState();
}

List dataCourses = [];

class _MylearningsState extends State<Mylearnings> {
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');

  void removeCourse(var x) async {
    // Call the user's CollectionReference to add a new user
    await courses
        .doc(x)
        .delete()
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  void listenToCourses() {
    // Listen to real-time updates from Firestore collection
    courses.snapshots().listen((snapshot) {
      setState(() {
        dataCourses =
            snapshot.docs; // Update data list with the latest documents
      });
    });
  }

  @override
  void initState() {
    listenToCourses();
    super.initState();
  }

  List<int> ids = [];
  List<ProgrammingCourse> enrolledCourses = [];

  @override
  Widget build(BuildContext context) {
    for (final x in dataCourses) {
      ids.add(x["id"]);
    }
    for (final x in programmingCourses) {
      if (ids.contains(x.id)) {
        enrolledCourses.add(x);
      }
    }

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("My Learning"),
      ),
      body: ListView.builder(
        itemCount: dataCourses.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: ValueKey(dataCourses[index]),
              onDismissed: (direction) {
                removeCourse(dataCourses[index].id);
              },
              child: CartItem(programmingCourse: enrolledCourses[index]));
        },
      ),
    );
  }
}
