import 'package:floating_view/floating_view.dart';

/// A widget that provides a floating, draggable, and resizable widget overlay.
///
/// The [FloatingView] is a stateful widget that allows you to overlay a floating
/// widget on top of your existing UI. The floating widget can be dragged around,
/// resized, and toggled between a collapsed and expanded state.
///
/// The floating widget's position, size, and behavior are controlled by a
/// [FloatingController] which must be provided to the [FloatingView].
///
/// The appearance of the floating widget can be customized using the [FloatingViewTheme].
///
/// The [FloatingView] requires a [childBuilder] function that builds the main
/// content of the widget, and a [controller] to manage the floating widget's state.
///
/// Example usage:
/// ```dart
/// FloatingView(
///   childBuilder: () => YourMainWidget(),
///   controller: FloatingController(),
///   theme: FloatingViewTheme(
///     elevation: 8.0,
///     backgroundColor: Colors.white,
///     radius: 16.0,
///   ),
/// )
/// ```
///
/// See also:
///  * [FloatingController], which manages the state and behavior of the floating widget.
///  * [FloatingViewTheme], which defines the appearance of the floating widget.
class FloatingView extends StatefulWidget {
  const FloatingView({
    super.key,
    required this.childBuilder,
    required this.controller,
    this.theme = const FloatingViewTheme(),
  });

  final Widget Function() childBuilder;

  final FloatingController controller;

  final FloatingViewTheme theme;

  @override
  FloatingViewState createState() => FloatingViewState();
}

class FloatingViewState extends State<FloatingView> {
  late FloatingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_updateState);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _floatingViewAnimatedPositionWrapper() => AnimatedPositioned(
    curve: Curves.ease,
    duration:
        !_controller.isMoving
            ? const Duration(milliseconds: 400)
            : Duration.zero,
    top:
        _controller.isCollapsed
            ? _controller.position.dy
            : MediaQuery.of(context).viewPadding.top,
    left: _controller.isCollapsed ? _controller.position.dx : 0,
    width:
        _controller.isCollapsed
            ? _controller.collapsedSize.width
            : _controller.screenSize.width,
    height:
        _controller.isCollapsed
            ? _controller.collapsedSize.height
            : _controller.screenSize.height,
    child: Hero(
      tag: 'ccp-floating-view',
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) => _floatingView(),
      child: _floatingView(),
    ),
  );

  Widget _floatingView() => GestureDetector(
    onTap: () {
      if (_controller.isCollapsed) _controller.toggleSize();
    },
    onPanStart: (_) {
      if (_controller.isCollapsed) _controller.toggleMoving();
    },
    onPanUpdate: (details) {
      if (_controller.isCollapsed) {
        _controller.position += details.delta;
      }
    },
    onPanEnd: (_) {
      if (_controller.isCollapsed) {
        _controller.snapToCorner();
        _controller.toggleMoving();
      }
    },
    child: Material(
      elevation: widget.theme.elevation,
      color: widget.theme.backgroundColor,
      borderRadius: BorderRadius.circular(
        _controller.isCollapsed ? widget.theme.radius : 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          _controller.isCollapsed ? widget.theme.radius : 0,
        ),
        child: Builder(
          builder: (context) {
            if (_controller.isCollapsed) {
              return _controller.minimizedChild!;
            } else {
              return _controller.maximizedChild!;
            }
          },
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.childBuilder(),
        if (_controller.hasChild) _floatingViewAnimatedPositionWrapper(),
      ],
    );
  }
}
