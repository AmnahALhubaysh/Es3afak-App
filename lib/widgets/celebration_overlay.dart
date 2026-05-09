import 'package:flutter/material.dart';
import 'dart:math';

class CelebrationOverlay extends StatefulWidget {
  final bool show;
  final VoidCallback onComplete;

  const CelebrationOverlay({super.key, required this.show, required this.onComplete});

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = List.generate(60, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _controller.reset();
      _controller.forward().then((_) => widget.onComplete());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.show 
      ? IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: ConfettiPainter(particles, _controller.value),
              );
            },
          ),
        )
      : const SizedBox.shrink();
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = -0.1;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  double size = Random().nextDouble() * 12 + 6;
  double speed = Random().nextDouble() * 0.4 + 0.6;
}

class ConfettiPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      // حساب موقع القصاصات بناءً على وقت التحريك
      final pos = Offset(p.x * size.width, (p.y + progress * p.speed) * size.height);
      paint.color = p.color.withOpacity(1 - progress); // تتلاشى تدريجياً
      canvas.drawRect(Rect.fromLTWH(pos.dx, pos.dy, p.size, p.size), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}