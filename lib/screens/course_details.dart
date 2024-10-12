// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/screens/course_videos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/programming_course.dart';
import 'package:http/http.dart' as http;

class CourseDetails extends ConsumerStatefulWidget {
  const CourseDetails({super.key, required this.programmingCourse});

  final ProgrammingCourse programmingCourse;

  @override
  ConsumerState<CourseDetails> createState() => _CourseDetailsState();
}

String addOrRemove = 'Add to Cart';
String enroll = "Enroll Now";
List data = [];
List dataCourses = [];

class _CourseDetailsState extends ConsumerState<CourseDetails> {
  @override
  void initState() {
    fetchYouTubePlaylistVideos();
    listenToFavorites();
    listenToCourses();
    super.initState();
  }

  List<String> videoIds = [];
  List<String> videoUrls = [];
  final String apiKey = 'AIzaSyA8itJq6qOHWdchrDkhOMI21UExsLX0Gio';
  void convertBetweenAddOrRemove() {
    if (addOrRemove == 'Add to Cart') {
      setState(() {
        addOrRemove = 'Remove from cart';
      });
    } else {
      setState(() {
        addOrRemove = 'Add to Cart';
      });
    }
  }

  String extractPlaylistId(String url) {
    final Uri uri = Uri.parse(url);

    // Check if the URL is from youtube.com and contains "playlist"
    if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      // Extract playlist ID from the query parameters
      return uri.queryParameters['list'] ?? '';
    }

    // Check for shortened URLs (though uncommon for playlists)
    if (uri.host == 'youtu.be') {
      return uri.pathSegments[0]; // This will return the segment after the /
    }

    return ''; // Return an empty string if no valid ID is found
  }

  // Fetch videos from the playlist
  Future<void> fetchYouTubePlaylistVideos() async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=${extractPlaylistId(widget.programmingCourse.link)}&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List videos = data['items'];
        // Extract video URLs
        setState(() {
          videoUrls = videos.map<String>((video) {
            final videoId = video['snippet']['resourceId']['videoId'];
            videoIds.add(videoId);
            return 'https://www.youtube.com/watch?v=$videoId'; // Construct the video URL
          }).toList();
        });
      } else {
        print('Failed to load playlist videos');
      }
    } catch (e) {
      print('Error fetching playlist videos: $e');
    }
  }

  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  void addFavorite(ProgrammingCourse favCourse) async {
    // Call the user's CollectionReference to add a new user
    await favorites
        .add({"id": favCourse.id})
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  void removeFavorite(var x) async {
    // Call the user's CollectionReference to add a new user
    await favorites
        .doc(x)
        .delete()
        .then((value) => log("User deleted"))
        .catchError((error) => log("Failed to delete user: $error"));
  }

  void listenToFavorites() {
    // Listen to real-time updates from Firestore collection
    favorites.snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.docs; // Update data list with the latest documents
      });
    });
  }

  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');

  void addCourse(ProgrammingCourse favCourse) async {
    // Call the user's CollectionReference to add a new user
    await courses
        .add({"id": favCourse.id})
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
  Widget build(BuildContext context) {
    var isExist = false;
    for (final x in data) {
      if (x["id"] == widget.programmingCourse.id) {
        setState(() {
          isExist = true;
        });
      }
    }
    var isCourseExist = false;
    for (final x in dataCourses) {
      if (x["id"] == widget.programmingCourse.id) {
        setState(() {
          isCourseExist = true;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.programmingCourse.id,
          child: Text(
            widget.programmingCourse.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(.2),
              ),
              onPressed: () {
                for (final fav in data) {
                  if (fav["id"] == widget.programmingCourse.id) {
                    removeFavorite(fav.id);
                    return;
                  }
                }
                addFavorite(widget.programmingCourse);
              },
              icon: Icon(
                isExist ? Icons.favorite : Icons.favorite_border,
                color: Colors.red[400],
              ))
        ],
      ),
      body: videoUrls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail or course image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: videoIds[0],
                          child: Image.network(
                            'https://img.youtube.com/vi/${videoIds[0]}/0.jpg', // Thumbnail from YouTube
                            width: MediaQuery.of(context).size.width * .9,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description section
                      Text(
                        widget.programmingCourse.description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Divider to create separation
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),

                      // Outlines section
                      const Text(
                        'Course Outline:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Display the outlines in a bullet list format
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            widget.programmingCourse.outlines.map((outline) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '\u2022', // Bullet point
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    outline,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Divider to create separation
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),

                      // Duration and link section with icons
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.blueAccent),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.programmingCourse.duration} h',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Divider for separating buttons
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      const SizedBox(height: 12),

                      // Buttons section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CourseVideos(
                                            programmingCourse:
                                                widget.programmingCourse,
                                          )));
                              for (final course in dataCourses) {
                                if (course["id"] ==
                                    widget.programmingCourse.id) {
                                  return;
                                }
                              }
                              addCourse(widget.programmingCourse);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 47, 34),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            icon: const Icon(Icons.check_circle),
                            label: Text(!isCourseExist
                                ? "Enroll Now"
                                : "Enrolled \nGo to Videos"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
