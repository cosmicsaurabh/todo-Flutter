import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const PaddedCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final defaultPadding = padding ?? const EdgeInsets.all(16);

    return Card(
      margin: cardTheme.margin,
      color: cardTheme.color,
      elevation: cardTheme.elevation,
      shadowColor: cardTheme.shadowColor,
      shape: cardTheme.shape,
      child: Padding(padding: defaultPadding, child: child),
    );
  }
}
