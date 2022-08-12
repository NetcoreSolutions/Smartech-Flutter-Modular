import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerDialog extends StatefulWidget {
  final String? videoUrl;

  const VideoPlayerDialog({Key? key, @required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  VideoPlayerController? _videoPlayerController1;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.videoUrl.toString());
    await Future.wait([
      _videoPlayerController1!.initialize(),
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      autoPlay: true,
      looping: false,
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      // subtitleBuilder: (context, subtitle) => Container(
      //   padding: const EdgeInsets.all(10.0),
      //   child: Text(
      //     subtitle,
      //     style: const TextStyle(color: Colors.white),
      //   ),
      // ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 30,
              offset: Offset(
                2,
                10,
              ),
            ),
          ],
        ),
        child: Center(
          child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
