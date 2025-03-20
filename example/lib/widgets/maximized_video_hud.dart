import 'package:example/example_export.dart';

class MaximizedVideoHud extends StatefulWidget {
  const MaximizedVideoHud({
    super.key,
    required this.videoController,
    required this.floatingController,
  });
  final VideoPlayerController videoController;
  final FloatingController floatingController;

  @override
  State<MaximizedVideoHud> createState() => MaximizedVideoHudState();
}

class MaximizedVideoHudState extends State<MaximizedVideoHud> {
  bool _show = true;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _cancelHideTimer();
    super.dispose();
  }

  void _startHideTimer() {
    _cancelHideTimer();
    _delay = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _show = false;
        });
      }
    });
  }

  void _cancelHideTimer() {
    _delay?.cancel();
    _delay = null;
  }

  void toggleShow() {
    setState(() {
      _show = !_show;
    });

    if (_show) {
      _startHideTimer();
    } else {
      _cancelHideTimer();
    }
  }

  void _rewind10Seconds() async {
    _startHideTimer();
    final currentPosition = await widget.videoController.position;
    if (currentPosition != null) {
      final newPosition = currentPosition - const Duration(seconds: 10);
      widget.videoController.seekTo(
        newPosition > Duration.zero ? newPosition : Duration.zero,
      );
    }
  }

  void _forward10Seconds() async {
    _startHideTimer();
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
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Visibility(
        visible: _show,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ActionButton(
                    size: 30,
                    color: Colors.white,
                    onTap: () => _rewind10Seconds(),
                    icon: Icons.fast_rewind_rounded,
                  ),
                  const SizedBox(width: 30),
                  ActionButton(
                    size: 50,
                    color: Colors.white,
                    onTap: () async {
                      _startHideTimer();
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
                  const SizedBox(width: 30),
                  ActionButton(
                    size: 30,
                    color: Colors.white,
                    onTap: () => _forward10Seconds(),
                    icon: Icons.fast_forward_rounded,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: ActionButton(
                color: Colors.white,
                onTap: () {
                  widget.floatingController.close();
                },
                icon: Icons.close_rounded,
              ),
            ),
            Positioned(
              right: 15,
              bottom: 15,
              child: ActionButton(
                color: Colors.white,
                onTap: () {
                  widget.floatingController.toggleSize();
                },
                icon: Icons.aspect_ratio,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
