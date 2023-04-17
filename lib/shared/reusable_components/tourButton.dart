import 'package:flutter/material.dart';

class TourButtton extends StatelessWidget {
  const TourButtton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  final String title;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),
          ),
        ),
      ),
    );
  }
}
