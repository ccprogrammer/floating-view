import 'package:example/example_export.dart';

class MinimizedVideoHud extends StatefulWidget {
  const MinimizedVideoHud({
    super.key,
    required this.videoController,
    required this.floatingController,
    required this.minimizedHeight,
  });
  final VideoPlayerController videoController;
  final FloatingController floatingController;
  final double minimizedHeight;

  @override
  State<MinimizedVideoHud> createState() => MinimizedVideoHudState();
}

class MinimizedVideoHudState extends State<MinimizedVideoHud> {
  void _rewind10Seconds() async {
    final currentPosition = await widget.videoController.position;
    if (currentPosition != null) {
      final newPosition = currentPosition - const Duration(seconds: 10);
      widget.videoController.seekTo(
        newPosition > Duration.zero ? newPosition : Duration.zero,
      );
    }
  }

  void _forward10Seconds() async {
    final currentPosition = await widget.videoController.position;
    if (currentPosition != null) {
      final maxDuration = widget.videoController.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 10);
      widget.videoController.seekTo(
        newPosition < maxDuration ? newPosition : maxDuration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.minimizedHeight * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionButton(
            onTap: _rewind10Seconds,
            icon: Icons.fast_rewind_rounded,
          ),
          const SizedBox(width: 20),
          ActionButton(
            onTap: () async {
              widget.videoController.value.isPlaying
                  ? await widget.videoController.pause()
                  : await widget.videoController.play();
              setState(() {});
            },
            icon:
                widget.videoController.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
          ),
          const SizedBox(width: 20),
          ActionButton(
            onTap: _forward10Seconds,
            icon: Icons.fast_forward_rounded,
          ),
        ],
      ),
    );
  }
}
