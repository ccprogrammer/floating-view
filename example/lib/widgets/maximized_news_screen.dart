import 'package:example/example_export.dart';

class MaximizedNewsScreen extends StatefulWidget {
  const MaximizedNewsScreen({
    super.key,
    required this.news,
    required this.controller,
  });
  final News news;
  final FloatingController controller;

  @override
  State<MaximizedNewsScreen> createState() => _MaximizedNewsScreenState();
}

class _MaximizedNewsScreenState extends State<MaximizedNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 40),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.controller.close();
                },
                child: Icon(Icons.close, size: 24),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  widget.controller.toggleSize();
                },
                child: Icon(Icons.aspect_ratio, size: 24),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.news.title,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.news.shortDescription,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.news.description,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const Text(
        //         'Related Articles',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //       ),
        //       const SizedBox(height: 8),
        //       ListView.builder(
        //         itemCount: moreList.length,
        //         shrinkWrap: true,
        //         physics: NeverScrollableScrollPhysics(),
        //         padding: EdgeInsets.zero,
        //         itemBuilder: (context, index) {
        //           final item = moreList[index];

        //           String title = '';
        //           String description = '';
        //           if (item is News) {
        //             title = item.title;
        //             description = item.shortDescription;
        //           } else if (item is Video) {
        //             title = item.title;
        //             description = item.description;
        //           }

        //           return ListTile(
        //             title: Text(title),
        //             contentPadding: EdgeInsets.zero,
        //             subtitle: Text(
        //               description,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //             ),

        //             onTap: () {
        //               FloatingController? controller;

        //               switch (item) {
        //                 case Video _:
        //                   VideoPlayerController? videoController;

        //                   videoController = VideoPlayerController.asset(
        //                       item.url,
        //                     )
        //                     ..initialize().then((_) {
        //                       videoController?.play();
        //                       setState(() {});
        //                     });

        //                   controller = FloatingController(
        //                     maximizedChild: MaximizedVideo(
        //                       videoController: videoController,
        //                       video: item,
        //                     ),
        //                     minimizedChild: MinimizedVideo(
        //                       videoController: videoController,
        //                       video: item,
        //                     ),
        //                     onDispose: () {
        //                       videoController?.dispose();
        //                     },
        //                   );
        //                   break;
        //                 case News _:
        //                   controller = FloatingController(
        //                     maximizedChild: MaximizedNewsScreen(news: item),
        //                     minimizedChild: MinimizedNewsScreen(news: item),
        //                     onDispose: () {},
        //                   );
        //                   break;
        //                 default:
        //                   break;
        //               }

        //               if (controller != null) {
        //                 floatingState?.setController(controller);
        //               }
        //             },
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
