import 'package:flutter/material.dart';

class PaymentIcon extends StatelessWidget {
  final String? imagePath;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentIcon({
    super.key,
    this.imagePath,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: imagePath != null
            ? Image.asset(imagePath!, width: 30, height: 30)
            : Icon(icon, color: Colors.blue),
      ),
    );
  }
}
