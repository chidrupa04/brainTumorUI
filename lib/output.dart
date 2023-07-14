import 'package:flutter/material.dart';
// import 'package:brain_tumor_detection/videopickerwidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ui_final/login.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --------------------------output video-----------------------
class Output extends StatefulWidget {
  final String? videoName; // Add the videoName parameter

  Output({this.videoName});
  @override
  _OutputState createState() => _OutputState();
}

class _OutputState extends State<Output> {
  firebase_storage.FirebaseStorage storage =firebase_storage.FirebaseStorage.instance;
  VideoPlayerController? videoPlayerController;
  VideoPlayerController? videoPlayerControllersecond;
  ChewieController? chewieController;
  ChewieController? chewieControllersecond;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  Future<void> loadVideo() async {
    // --------fetch video from output------------------
    final videoUrl = await storage
        .ref('/videos/output.mp4') // Replace with your video's storage path
        .getDownloadURL();

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await videoPlayerController?.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: false, // Set to false if you don't want the video to play automatically
      looping: true, // Set to false if you don't want the video to loop
    );
    // -------------------------------------------------------
    // final videoUrlsec = await storage.ref('original_mask/049_video.mp4').getDownloadURL();
    //
    // videoPlayerControllersecond = VideoPlayerController.network(videoUrlsec);
    // await videoPlayerControllersecond?.initialize();
    //
    // chewieControllersecond = ChewieController(
    //   videoPlayerController: videoPlayerControllersecond!,
    //   autoPlay: false, // Set to false if you don't want the video to play automatically
    //   looping: true, // Set to false if you don't want the video to loop
    // );
    //
    // setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    videoPlayerControllersecond?.dispose();
    chewieController?.dispose();
    chewieControllersecond?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var videoPlayerController2;
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediciton Result'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children:[
            // Text('The Ground Truth Mask of the patient'),
            // Text(widget.videoName??' '),
            // Container(
            //   width: 400.0, // Adjust the width as desired
            //   height: 400.0,
            //   child: chewieControllersecond != null &&chewieControllersecond!.videoPlayerController.value.isInitialized ? Chewie(controller: chewieControllersecond!,): CircularProgressIndicator(),
            // ),
            // SizedBox(height: 10),
            Text('The Identified tumor region from the video'),
            Container(
              width: 400.0, // Adjust the width as desired
              height: 400.0,
              child: chewieController != null &&chewieController!.videoPlayerController.value.isInitialized ? Chewie(controller: chewieController!,): CircularProgressIndicator(),
            ),
            SizedBox(
              height:30,
            ),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context,'first' );
            }, child: Text(
              'Sign out'
            ))
          ]
      ),
    );
  }
}