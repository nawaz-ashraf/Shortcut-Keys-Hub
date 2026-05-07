import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/haptics.dart';

/// A premium neumorphic circular back button with smooth ripple animation.
/// Adapts automatically for dark/light mode.
class PremiumBackButton extends StatefulWidget {
  const PremiumBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<PremiumBackButton> createState() => _PremiumBackButtonState();
}

class _PremiumBackButtonState extends State<PremiumBackButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await AppHaptics.light();
    _controller.forward().then((_) => _controller.reverse());
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else if (context.mounted && context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF1E2128)
        : const Color(0xFFE8ECF4);
    final iconColor = isDark
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.75);
    final shadowDark = isDark
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.15);
    final shadowLight = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.8);

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: shadowDark,
                offset: const Offset(3, 3),
                blurRadius: 8,
              ),
              BoxShadow(
                color: shadowLight,
                offset: const Offset(-3, -3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: iconColor,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
