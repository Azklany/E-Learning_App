import 'package:e_learning_app/data/course_data.dart';
import 'package:e_learning_app/model/programming_course.dart';
import 'package:flutter/material.dart';
import '../drawer/mydrawer.dart';
import '../widgets/course_item.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<int> ids = [];
  List<ProgrammingCourse> favCourses = [];

  @override
  Widget build(BuildContext context) {
    for (final x in data) {
      ids.add(x["id"]);
    }
    for (final x in programmingCourses) {
      if (ids.contains(x.id)) {
        favCourses.add(x);
      }
    }
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("Favourite"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return CourseItem(programmingCourse: favCourses[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey[400],
            height: 1,
          );
        },
        itemCount: ids.length,
      ),
    );
  }
}
