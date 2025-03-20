import 'package:example/example_export.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final double size;
  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: size),
    );
  }
}
