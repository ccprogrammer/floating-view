import 'package:floating_view/floating_view.dart';

/// Enum representing the possible positions for the floating widget.
enum FloatingPosition { 
  /// Position the floating widget at the top left corner.
  topLeft, 
  
  /// Position the floating widget at the top right corner.
  topRight, 
  
  /// Position the floating widget at the bottom left corner.
  bottomLeft, 
  
  /// Position the floating widget at the bottom right corner.
  bottomRight 
}

/// Controller for managing the state and behavior of a floating widget.
class FloatingController extends ChangeNotifier {
  /// Creates a [FloatingController] with the given parameters.
  ///
  /// The [context] is required to access the [MediaQuery] data.
  /// The [collapsedHeight], [topMargin], [bottomMargin], [padding], and [initialPosition]
  /// are optional parameters with default values.
  FloatingController(
    this.context, {
    this.collapsedHeight = 170,
    this.topMargin = 75,
    this.bottomMargin = 20,
    this.padding = 20,
    this.initialPosition = FloatingPosition.bottomRight,
  });

  /// The height of the floating widget when it is collapsed.
  final double collapsedHeight;

  /// The margin from the top of the screen.
  final double topMargin;

  /// The margin from the bottom of the screen.
  final double bottomMargin;

  /// The padding around the floating widget.
  final double padding;

  /// The initial position of the floating widget.
  final FloatingPosition initialPosition;

  /// The [BuildContext] used to access [MediaQuery] data.
  final BuildContext context;

  /// The widget to display when the floating widget is maximized.
  Widget? _maximizedChild;

  /// The widget to display when the floating widget is minimized.
  Widget? _minimizedChild;

  /// Whether the floating widget is currently collapsed.
  bool _isCollapsed = false;

  /// Whether the floating widget is currently being moved.
  bool _isMoving = false;

  /// The current position of the floating widget.
  Offset _position = Offset(20, 20);

  /// The size of the floating widget when it is collapsed.
  late Size _collapsedSize;

  /// The [MediaQueryData] for the current context.
  late final MediaQueryData _mediaQuery = MediaQuery.of(context);

  /// Callback to be called when the floating widget is disposed.
  VoidCallback? _onDispose;

  /// Whether the floating widget is currently collapsed.
  bool get isCollapsed => _isCollapsed;

  /// Whether the floating widget is currently being moved.
  bool get isMoving => _isMoving;

  /// Whether the floating widget has both minimized and maximized children.
  bool get hasChild => _minimizedChild != null && _maximizedChild != null;

  /// The widget to display when the floating widget is maximized.
  Widget? get maximizedChild => _maximizedChild;

  /// The widget to display when the floating widget is minimized.
  Widget? get minimizedChild => _minimizedChild;

  /// The current position of the floating widget.
  Offset get position => _position;

  /// The size of the screen.
  Size get screenSize => _mediaQuery.size;

  /// The size of the floating widget when it is collapsed.
  Size get collapsedSize => _collapsedSize;

  /// Sets the new position of the floating widget and notifies listeners.
  set position(Offset newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  /// Initializes the floating widget with the given children and dispose callback.
  ///
  /// The [maxChild] is the widget to display when the floating widget is maximized.
  /// The [minChild] is the widget to display when the floating widget is minimized.
  /// The [onDispose] callback is called when the floating widget is disposed.
  void initialize({
    required Widget maxChild,
    required Widget minChild,
    required VoidCallback onDispose,
  }) {
    close(); // Ensure previous state is cleaned up
    _maximizedChild = maxChild;
    _minimizedChild = minChild;
    _onDispose = onDispose;
    notifyListeners();
  }

  /// Calculates the position of the floating widget based on the given parameters.
  ///
  /// The [position] is the desired position of the floating widget.
  /// The [screenSize] is the size of the screen.
  /// The [containerSize] is the size of the floating widget.
  /// The [mediaQuery] is the [MediaQueryData] for the current context.
  Offset _calculatePosition(
    FloatingPosition position,
    Size screenSize,
    Size containerSize,
    MediaQueryData mediaQuery,
  ) {
    switch (position) {
      case FloatingPosition.topLeft:
        return Offset(padding, mediaQuery.viewPadding.top + topMargin);
      case FloatingPosition.topRight:
        return Offset(
          screenSize.width - padding - containerSize.width,
          mediaQuery.viewPadding.top + topMargin,
        );
      case FloatingPosition.bottomLeft:
        return Offset(
          padding,
          screenSize.height -
              containerSize.height -
              mediaQuery.viewPadding.bottom -
              bottomMargin,
        );
      case FloatingPosition.bottomRight:
        return Offset(
          screenSize.width - padding - containerSize.width,
          screenSize.height -
              containerSize.height -
              mediaQuery.viewPadding.bottom -
              bottomMargin,
        );
    }
  }

  /// Toggles the size of the floating widget between collapsed and expanded.
  void toggleSize() {
    _collapsedSize = Size(screenSize.width - padding * 7, collapsedHeight);
    _position = _calculatePosition(
      initialPosition,
      screenSize,
      _collapsedSize,
      _mediaQuery,
    );
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }

  /// Toggles the moving state of the floating widget.
  void toggleMoving() {
    _isMoving = !_isMoving;
    notifyListeners();
  }

  /// Closes the floating widget and cleans up resources.
  void close() {
    _isCollapsed = false;
    _maximizedChild = null;
    _minimizedChild = null;
    _position = Offset(20, 20);
    _onDispose?.call();
    _onDispose = null;
    notifyListeners();
  }

  /// Snaps the floating widget to the nearest corner.
  void snapToCorner() {
    double dx = position.dx;
    double dy = position.dy;

    final corners = [
      Offset(padding, _mediaQuery.viewPadding.top + topMargin),
      Offset(
        screenSize.width - padding - _collapsedSize.width,
        _mediaQuery.viewPadding.top + topMargin,
      ),
      Offset(
        padding,
        screenSize.height -
            _collapsedSize.height -
            _mediaQuery.viewPadding.bottom -
            bottomMargin,
      ),
      Offset(
        screenSize.width - padding - _collapsedSize.width,
        screenSize.height -
            _collapsedSize.height -
            _mediaQuery.viewPadding.bottom -
            bottomMargin,
      ),
    ];

    final closestCorner = corners.reduce((a, b) {
      final distanceA = (a.dx - dx).abs() + (a.dy - dy).abs();
      final distanceB = (b.dx - dx).abs() + (b.dy - dy).abs();
      return distanceA < distanceB ? a : b;
    });

    _position = closestCorner;
    notifyListeners();
  }

  /// Disposes the floating widget and cleans up resources.
  @override
  void dispose() {
    close();
    super.dispose();
  }
}
