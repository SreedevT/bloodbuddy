import 'package:flutter/material.dart';

class CricularIconButtonWithTooltip extends StatelessWidget {
  final String tooltipMessage;
  final Function onPressed;
  final IconData icon;
  final Color? iconColor;
  const CricularIconButtonWithTooltip({
    super.key,
    required this.tooltipMessage,
    required this.onPressed,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: ElevatedButton(
        onPressed: () => onPressed,
        style: ElevatedButton.styleFrom(
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.grey.shade400,
                width:1,
              ),
            ),
            padding: const EdgeInsets.all(10)),
        child: Center(child: Icon(icon, color: iconColor)),
      ),
    );
  }
}
