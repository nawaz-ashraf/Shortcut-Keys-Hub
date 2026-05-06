import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicCard extends StatelessWidget {
  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).cardColor;
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 6,
        intensity: 0.8,
        surfaceIntensity: 0.4,
        color: color,
        shadowDarkColor: Colors.black.withOpacity(0.4),
        shadowLightColor: Colors.white.withOpacity(0.2),
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(borderRadius),
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
