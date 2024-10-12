import 'dart:developer';

import 'package:e_learning_app/model/programming_course.dart';
import 'package:flutter/material.dart';

import '../data/course_data.dart';
import '../drawer/mydrawer.dart';
import '../widgets/course_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

var cat = "";
Category category = Category.all;

class _HomeState extends State<Home> {
  List<ProgrammingCourse> filter() {
    return programmingCourses
        .where(
          (element) => element.categories.contains(category),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Category.values.length,
                itemBuilder: (context, index) {
                  String cat = '';
                  Color bgColor = Colors.grey.shade200;
                  Color textColor = Colors.black;
                  FontWeight fontWeight = FontWeight.normal;

                  // Setting category names and styles based on conditions
                  if (Category.values[index] == Category.all) {
                    cat = "All";
                    bgColor = Colors.blue.shade600;
                    textColor = Colors.white;
                    fontWeight = FontWeight.bold;
                  } else if (Category.values[index] ==
                      Category.mobiledevelopment) {
                    cat = "Mobile Development";
                    bgColor = Colors.orange.shade300;
                    textColor = Colors.white;
                  } else if (Category.values[index] == Category.ai) {
                    cat = "AI";
                    bgColor = Colors.purple.shade300;
                    textColor = Colors.white;
                  } else if (Category.values[index] == Category.datascience) {
                    cat = "Data Science";
                    bgColor = Colors.teal.shade300;
                    textColor = Colors.white;
                  } else if (Category.values[index] == Category.devops) {
                    cat = "Dev Ops";
                    bgColor = Colors.red.shade400;
                    textColor = Colors.white;
                  } else if (Category.values[index] ==
                      Category.webdevelopment) {
                    cat = "Web Development";
                    bgColor = Colors.green.shade400;
                    textColor = Colors.white;
                  }

                  return InkWell(
                    onTap: () {
                      setState(() {
                        category = Category.values[index];
                      });
                      log(category.name);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: fontWeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return CourseItem(programmingCourse: filter()[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.grey[400],
                    height: 1,
                  );
                },
                itemCount: filter().length,
              ),
            ),
          ],
        ));
  }
}
