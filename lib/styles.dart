import 'package:flutter/material.dart';

const double kPremiumCardElevation = 1.0;
const double kPremiumCardBorderRadius = 16.0;
const EdgeInsetsGeometry kPremiumCardPadding = EdgeInsets.all(16);

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final Color? borderColor;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = kPremiumCardPadding,
    this.elevation = kPremiumCardElevation,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kPremiumCardBorderRadius),
        side: borderColor != null ? BorderSide(color: borderColor!, width: 1) : BorderSide.none,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
