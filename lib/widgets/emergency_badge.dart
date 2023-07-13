import 'package:flutter/material.dart';

class EmergencyTriangleBadge extends StatelessWidget {
  final Color color;
  final double size;
  final String text;
  final TextStyle textStyle;

  const EmergencyTriangleBadge({
    Key? key,
    this.color = Colors.red,
    this.size = 24.0,
    this.text = "Emergency",
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrianglePainter(color),
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
