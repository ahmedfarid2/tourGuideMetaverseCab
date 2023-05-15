import 'package:flutter/material.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/TourOutlineButton.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class CallSheet extends StatelessWidget {
  const CallSheet({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(
              0.7,
              0.7,
            ),
          ),
        ],
      ),
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'you are now going to call the tourist',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: BrandColors.colorTextLight,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Brand-Bold',
                color: BrandColors.colorText,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TourOutlineButton(
                      title: 'BACK',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: BrandColors.colorLightGrayFair,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    child: TourButtton(
                      title: 'CALL',
                      color: BrandColors.colorGreen,
                      onPressed: onPressed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
