import 'package:flutter/material.dart';

class OccupancyBar extends StatelessWidget {
  const OccupancyBar({
    super.key,
    required this.current,
    required this.total,
    this.showLabel = true,
    this.height = 10,
    this.lowColor,
    this.midColor,
    this.highColor,
  });

  final int current;
  final int total;
  final bool showLabel;
  final double height;
  final Color? lowColor;
  final Color? midColor;
  final Color? highColor;

  double get _progress {
    if (total <= 0) {
      return 0;
    }

    return (current / total).clamp(0.0, 1.0);
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);

    if (_progress >= 0.9) {
      return highColor ?? theme.colorScheme.error;
    }

    if (_progress >= 0.6) {
      return midColor ?? Colors.amber;
    }

    return lowColor ?? Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final percentual = (_progress * 100).round();
    final color = _getColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: height,
            color: color,
          ),
        ),

        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            '$current/$total assentos • $percentual%',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
