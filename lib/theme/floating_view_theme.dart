import 'package:floating_view/floating_view.dart';

/// A theme for the [FloatingView].
class FloatingViewTheme {
  /// The elevation of the floating widget.
  final double elevation;

  /// The background color of the floating widget.
  final Color? backgroundColor;

  /// The border radius of the floating widget.
  final double radius;

  /// Creates a [FloatingViewTheme].
  ///
  /// All parameters have default values.
  const FloatingViewTheme({
    this.elevation = 2,
    this.backgroundColor,
    this.radius = 12,
  });
}
