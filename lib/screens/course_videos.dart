// ignore_for_file: library_private_types_in_public_api, avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/model/programming_course.dart';
import 'package:e_learning_app/screens/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class CourseVideos extends StatefulWidget {
  const CourseVideos({super.key, required this.programmingCourse});

  final ProgrammingCourse programmingCourse;

  @override
  _CourseVideosState createState() => _CourseVideosState();
}

List videosData = [];

class _CourseVideosState extends State<CourseVideos> {
  final String apiKey =
      'AIzaSyA8itJq6qOHWdchrDkhOMI21UExsLX0Gio'; // Replace with your YouTube API key
  // final String playlistId = widget.programmingCourse.link; // Playlist ID
  List<String> videoUrls = [];
  List<String> videoIds = [];
  List<String> videoTitless = [];
  List<String> videoDescriptions = [];
  List<bool> isCompleted = [];

  @override
  void initState() {
    super.initState();fetchYouTubePlaylistVideos();
    listenToVideos();
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
        List<String> videoTitles = [];
        List<String> videoDes = [];

        for (var item in data['items']) {
          videoTitles.add(item['snippet']['title']);
          videoDes.add(item['snippet']['description']);
        }
        videoTitless = videoTitles;
        videoDescriptions = videoDes;
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
    if (widget.programmingCourse.completed.isEmpty) {
      widget.programmingCourse.completed = List.filled(videoUrls.length, false);
    }
    isCompleted = widget.programmingCourse.completed;
  }

  void goNext(int index) {
    index < videoUrls.length - 1
        ? Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Video(

                  addVideo: addVideo,
                  goBack: goBack,
                  goNext: goNext,
                  description: videoDescriptions[index + 1],
                  videoTitle: videoTitless[index + 1],
                  index: index + 1,
                  videoId: videoIds[index + 1],
              programmingCourse: widget.programmingCourse,
                )))
        : null;
  }

  void goBack(int index) {
    index > 0
        ? Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Video(
                  addVideo: addVideo,
                  goBack: goBack,
                  goNext: goNext,
                  description: videoDescriptions[index - 1],
                  videoTitle: videoTitless[index - 1],
                  index: index - 1,
                  videoId: videoIds[index - 1],
              programmingCourse: widget.programmingCourse,
                )))
        : null;
  }

  CollectionReference videosDone =
      FirebaseFirestore.instance.collection('videos');
  void addVideo(String id) async {
    check(id)
        ? null
        : await videosDone
            .add({"id": id})
            .then((value) => log("video Added"))
            .catchError((error) => log("Failed to add user: $error"));
  }

  void removeVideo(String id) async {
    // Call the user's CollectionReference to add a new user
    await videosDone
        .doc(id)
        .delete()
        .then((value) => log("video Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  void listenToVideos() {
    // Listen to real-time updates from Firestore collection
    videosDone.snapshots().listen((snapshot) {
      setState(() {
        videosData =
            snapshot.docs; // Update data list with the latest documents
      });
    });
  }

  bool check(String id) {
    for (final video in videosData) {
      if (video["id"] == id) {
        return true;
      }
    }
    return false;
  }

  dynamic getId(String id) {
    for (final video in videosData) {
      if (video["id"] == id) {
        return video.id;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.programmingCourse.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
      body: videoUrls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                        tag: videoIds[index],
                        child: Image.network(
                          'https://img.youtube.com/vi/${videoIds[index]}/0.jpg', // Thumbnail from YouTube
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      videoTitless[index],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    subtitle: Text(
                      videoDescriptions[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                    ),
                    trailing: Checkbox(
                        value: check(videoIds[index]),
                        onChanged: (e) {
                          check(videoIds[index])
                              ? removeVideo(getId(videoIds[index]))
                              : addVideo(videoIds[index]);
                        }),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Video(
                                addVideo: addVideo,

                                goBack: goBack,
                                goNext: goNext,
                                description: videoDescriptions[index],
                                videoTitle: videoTitless[index],
                                index: index,
                                videoId: videoIds[index],
                            programmingCourse: widget.programmingCourse,
                              )));
                    },
                  ),
                );
              },
            ),
    );
  }
}
