import 'package:flutter/material.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';

class TourOutlineButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final Color color;

  const TourOutlineButton(
      {super.key, required this.title, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        backgroundColor: color,
        primary: color,
      ),
      onPressed: onPressed,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(title,
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Brand-Bold',
                  color: BrandColors.colorText)),
        ),
      ),
    );
  }
}
