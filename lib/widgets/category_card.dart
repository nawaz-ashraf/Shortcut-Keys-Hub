import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/utils/haptics.dart';
import '../models/category.dart';
import 'neumorphic_card.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.count,
    required this.onTap,
  });

  final ShortcutCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        await AppHaptics.light();
        onTap();
      },
      child:
          NeumorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogo(theme),
                    const Spacer(),
                    Text(
                      category.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$count shortcuts',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.textTheme.labelMedium?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 350.ms)
              .scale(begin: const Offset(0.98, 0.98), curve: Curves.easeOut),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    if (category.logoUrl != null) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category.accent.withOpacity(0.15),
        ),
        child: Center(
          child: SvgPicture.network(
            category.logoUrl!,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white.withOpacity(0.9) : category.accent,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              category.icon,
              color: category.accent,
              size: 22,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: category.accent.withOpacity(0.2),
      child: Icon(category.icon, color: category.accent),
    );
  }
}
