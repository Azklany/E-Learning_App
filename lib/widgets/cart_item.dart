import 'package:e_learning_app/screens/course_videos.dart';
import 'package:flutter/material.dart';
import '../model/programming_course.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.programmingCourse});

  final ProgrammingCourse programmingCourse;

  @override
  State<CartItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (e) =>
              CourseVideos(programmingCourse: widget.programmingCourse),
        ));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // Increased width
        height: MediaQuery.of(context).size.height * 0.6, // Increased height
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // More rounded corners
          ),
          elevation: 10, // Increased elevation for depth
          margin: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 15), // Spacing around the card
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top:
                          Radius.circular(20)), // Rounded top corners for image
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKpIzUJV8BNUc9XMaSXM3Wm114SRLacJnHSg&s", // Assuming imageUrl is a property of programmingCourse
                    height: 150, // Height of the image
                    width: double.infinity, // Full width of the card
                    fit: BoxFit.cover, // Cover the space without distortion
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(15.0), // Padding around the text
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      Text(
                        widget.programmingCourse.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Color for course title
                        ),
                      ),
                      const SizedBox(height: 5), // Spacing
                      Text(
                        widget.programmingCourse.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700], // Color for description
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10), // Spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${widget.programmingCourse.duration}h ",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors
                                          .orangeAccent, // Color for duration
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey[600],
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
