import 'package:example/example_export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Widget',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FloatingController _controller = FloatingController(
    context,
    initialPosition: FloatingPosition.bottomLeft,
    isDraggable: true,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(title: Text('Floating Widget'));

    final fab = FloatingActionButton(
      child: Icon(Icons.navigate_next),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => FloatingView(
                  controller: _controller,
                  childBuilder: () => NavigationTestScreen(),
                ),
          ),
        );
      },
    );

    return FloatingView(
      controller: _controller,
      childBuilder:
          () => Scaffold(
            appBar: appbar,
            floatingActionButton: fab,
            body: ItemBuilder(list: dummyList, controller: _controller),
          ),
    );
  }
}

class ItemBuilder extends StatefulWidget {
  const ItemBuilder({super.key, required this.list, required this.controller});
  final List<dynamic> list;
  final FloatingController controller;

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  void onTap(dynamic data) {
    switch (data) {
      case Video _:
        VideoPlayerController? videoController;
        videoController =
            VideoPlayerController.asset(data.url)
              ..initialize().then((_) {
                videoController?.play();
                setState(() {});
              })
              ..addListener(() {
                setState(() {});
              });
        {}

        widget.controller.initialize(
          maxChild: MaximizedVideo(
            videoController: videoController,
            floatingController: widget.controller,
            video: data,
          ),
          minChild: MinimizedVideo(
            videoController: videoController,
            floatingController: widget.controller,
            video: data,
          ),
          onDispose: () {
            videoController?.dispose();
          },
        );

        break;
      case News _:
        widget.controller.initialize(
          maxChild: MaximizedNewsScreen(
            news: data,
            controller: widget.controller,
          ),
          minChild: MinimizedNewsScreen(
            news: data,
            controller: widget.controller,
          ),
          onDispose: () {},
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        final item = widget.list[index];

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
          subtitle: Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          onTap: () {
            onTap(item);
          },
        );
      },
    );
  }
}
