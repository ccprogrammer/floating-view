import 'package:example/example_export.dart';

class MaximizedVideo extends StatefulWidget {
  const MaximizedVideo({
    super.key,
    required this.videoController,
    required this.floatingController,
    required this.video,
  });
  final VideoPlayerController videoController;
  final FloatingController floatingController;
  final Video video;

  @override
  State<MaximizedVideo> createState() => _MaximizedVideoState();
}

class _MaximizedVideoState extends State<MaximizedVideo> {
  final GlobalKey<MaximizedVideoHudState> _hudKey =
      GlobalKey<MaximizedVideoHudState>();

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
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _hudKey.currentState?.toggleShow();
          },
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child:
                        widget.videoController.value.isInitialized
                            ? AspectRatio(
                              aspectRatio:
                                  widget.videoController.value.aspectRatio,
                              child: VideoPlayer(widget.videoController),
                            )
                            : Container(),
                  ),
                ),
              ),
              Positioned.fill(
                child: MaximizedVideoHud(
                  key: _hudKey,
                  videoController: widget.videoController,
                  floatingController: widget.floatingController,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    widget.videoController,
                    allowScrubbing: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              padding: EdgeInsets.only(bottom: 50),
              primary: false,
              children: [
                Text(
                  widget.video.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(widget.video.description, style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.thumb_up, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('1M'),
                    SizedBox(width: 16),
                    Icon(Icons.thumb_down, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('531'),
                    SizedBox(width: 16),
                    Icon(Icons.share, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Share'),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.grey),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flutter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '1M subscribers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('SUBSCRIBE'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Related Articles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        itemCount: moreList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final item = moreList[index];

                          String title = '';
                          String description = '';
                          if (item is News) {
                            title = item.title;
                            description = item.shortDescription;
                          } else if (item is Video) {
                            title = item.title;
                            description = item.description;
                          }

                          return ListTile(
                            title: Text(title),
                            contentPadding: EdgeInsets.zero,
                            subtitle: Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            onTap: () {
                              switch (item) {
                                case Video _:
                                  VideoPlayerController? videoController;
                                  videoController =
                                      VideoPlayerController.asset(item.url)
                                        ..initialize().then((_) {
                                          videoController?.play();
                                          setState(() {});
                                        })
                                        ..addListener(() {
                                          setState(() {});
                                        });

                                  widget.floatingController.initialize(
                                    maxChild: MaximizedVideo(
                                      videoController: videoController,
                                      floatingController:
                                          widget.floatingController,
                                      video: item,
                                    ),
                                    minChild: MinimizedVideo(
                                      videoController: videoController,
                                      floatingController: widget.floatingController,
                                      video: item,
                                    ),
                                    onDispose: () {
                                      videoController?.dispose();
                                    },
                                  );

                                  break;
                                case News _:
                                  widget.floatingController.initialize(
                                    maxChild: MaximizedNewsScreen(
                                      news: item,
                                      controller: widget.floatingController,
                                    ),
                                    minChild: MinimizedNewsScreen(
                                      news: item,
                                      controller: widget.floatingController,
                                    ),
                                    onDispose: () {},
                                  );
                                  break;
                                default:
                                  break;
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
