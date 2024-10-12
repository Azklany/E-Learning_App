// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final String description;
  final int index; // Video Index
  final YoutubePlayerController _controller;
  final void Function(int index) goNext;
  final void Function(int index) goBack;
  final void Function(String id) addVideo;

  Video({
    super.key,
    required this.videoId,
    required this.index,
    required this.videoTitle,
    required this.description,
    required this.goNext,
    required this.goBack,
    required this.addVideo,
  }) : _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            enableCaption: true,
            showLiveFullscreenButton: true,
            controlsVisibleAtStart: true,
            autoPlay: false,
            mute: false,
          ),
        );

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  bool isFullScreen = false;
  void fullScreenListener() {
    // Check if fullscreen mode has changed
    if (widget._controller.value.isFullScreen != isFullScreen) {
      setState(() {
        isFullScreen = widget._controller.value.isFullScreen;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Add a listener to detect changes in fullscreen mode
  //   widget._controller.addListener(fullScreenListener);
  // }

  // @override
  // void dispose() {
  //   // Remove the listener to avoid memory leaks
  //   widget._controller.removeListener(fullScreenListener);
  //   widget._controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    widget.addVideo(widget.videoId);
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode background
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.redAccent,
              title: Text(
                widget.videoTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true, // Align title to center
            ),
      body: Column(
        children: [
          // Video Player with defined aspect ratio
          AspectRatio(
            aspectRatio: isFullScreen
                ? MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height
                : 16 / 9,
            child: YoutubePlayer(
              bottomActions: [
                const PlaybackSpeedButton(),
                IconButton(
                    onPressed: () {
                      widget._controller.toggleFullScreenMode();
                      fullScreenListener();
                    },
                    icon: const Icon(Icons.fullscreen)),
                const CurrentPosition(), // Show current position of video
                const ProgressBar(
                  isExpanded: true,
                  colors: ProgressBarColors(
                    playedColor: Colors.redAccent,
                    handleColor: Colors.redAccent,
                  ),
                ),
                const RemainingDuration(), // Show remaining time
              ],
              topActions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Add functionality for settings (optional)
                  },
                ),
              ],
              controller: widget._controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.redAccent,
              onReady: () {
                print('Player is ready.');
              },
            ),
          ),
          if (!isFullScreen)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.videoTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(
                          height: 20), // Add some space before buttons
                    ],
                  ),
                ),
              ),
            ),
          if (!isFullScreen)
            Container(
              color: const Color.fromARGB(255, 35, 37, 37),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 130,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.goBack(widget.index);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.goNext(widget.index);
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
