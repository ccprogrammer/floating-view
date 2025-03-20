import 'package:example/example_export.dart';

class MinimizedVideo extends StatefulWidget {
  const MinimizedVideo({
    super.key,
    required this.videoController,
    required this.floatingController,
    required this.video,
  });
  final VideoPlayerController videoController;
  final FloatingController floatingController;
  final Video video;

  @override
  State<MinimizedVideo> createState() => _MinimizedVideoState();
}

class _MinimizedVideoState extends State<MinimizedVideo> {
  @override
  void initState() {
    super.initState();
    widget.videoController.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    widget.videoController.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  void _onVideoControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              color: Colors.grey,
              height: constraints.maxHeight * 0.7,
              child: Center(
                child:
                    widget.videoController.value.isInitialized
                        ? AspectRatio(
                          aspectRatio: widget.videoController.value.aspectRatio,
                          child: VideoPlayer(widget.videoController),
                        )
                        : Container(),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: ActionButton(
                icon: Icons.close,
                onTap: () => widget.floatingController.close(),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VideoProgressIndicator(
                      widget.videoController,
                      allowScrubbing: true,
                    ),
                    MinimizedVideoHud(
                      videoController: widget.videoController,
                      minimizedHeight: constraints.maxHeight,
                      floatingController: widget.floatingController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
