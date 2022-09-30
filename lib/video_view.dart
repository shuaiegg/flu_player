import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/player.dart';

class VideoView extends StatefulWidget {
  const VideoView(this.player,{this.fit = FijkFit.contain});

  final Player player;
  final FijkFit fit;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: onTapVideo,
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: true,
            child: FijkView(player: widget.player,fit: widget.fit,),
          ),
          if (widget.player.state == FijkState.paused)
            Align(
              child: Image.asset('asset/images/play.png'),
              alignment: Alignment.center,
            ),
        ],
      ),
    ));
  }

  void onTapVideo() {
    print('onTapVideo');
    if (widget.player.state == FijkState.paused) {
      widget.player.start();
    } else {
      widget.player.pause();
    }
    setState(() {});
  }

  @override
  void dispose(){
    super.dispose();
    widget.player.release();
  }

}
