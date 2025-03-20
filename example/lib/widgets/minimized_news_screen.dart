import 'package:example/example_export.dart';

class MinimizedNewsScreen extends StatefulWidget {
  const MinimizedNewsScreen({
    super.key,
    required this.news,
    required this.controller,
  });
  final News news;
  final FloatingController controller;

  @override
  State<MinimizedNewsScreen> createState() => _MinimizedNewsScreenState();
}

class _MinimizedNewsScreenState extends State<MinimizedNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.news.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.0),
              Text(
                widget.news.shortDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
