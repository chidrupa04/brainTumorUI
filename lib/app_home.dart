import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:ui_final/output.dart';

class VideoPickerWidget extends StatefulWidget {
  final Function(File? video) onVideoSelected;

  VideoPickerWidget({required this.onVideoSelected});

  @override
  _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  File? _video;
  String? _videoName;

  Future _pickVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedVideo != null) {
        _video = File(pickedVideo.path);
        _videoName = pickedVideo.path.split('/').last;
        widget.onVideoSelected(_video); // Call the callback function
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: _pickVideo,
          child: Text('Select Video'),
        ),
        SizedBox(height: 16.0),
        _video != null
            ? Column(
          children: [
            Container(
              width: 400.0, // Adjust the width as desired
              height: 400.0, // Adjust the height as desired
              child: VideoPlayerWidget(videoFile: _video!),
            ),
            SizedBox(height: 8.0),
            Text('Video Name: $_videoName'),
          ],
        )
            : Text('No video selected.'),
      ],
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedVideo;

  void _handleVideoSelected(File? video) {
    setState(() {
      _selectedVideo = video;
    });
  }

  void _sendApiRequest() async {
    if (_selectedVideo != null) {
      // Prepare the API endpoint URL
      String apiUrl = 'http://13.53.197.118/process_video';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add the selected video file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedVideo!.path,
      ));

      try {
        // Send the API request
        var response = await request.send();

        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          // Read the response
          var responseJson = await response.stream.bytesToString();

          // Process the response as needed
          var responseData = jsonDecode(responseJson);

          // Handle the response data
          // ...
        } else {
          // Handle API error
          print('API request failed with status code ${response.statusCode}');
        }
      } catch (error) {
        // Handle any errors during the API request
        print('API request error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.blue,
        title: Text('Home Page'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // Perform logout
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              "Select a video to predict",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            VideoPickerWidget(onVideoSelected: _handleVideoSelected),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.blue,
              ),
              onPressed: _sendApiRequest,
              child: Text('Predict'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Output()),
                );
              },


              child: Text('Results'),
            ),


          ],
        ),
      ),
    );
  }
}