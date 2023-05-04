import 'package:flutter/material.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/shared/helpers/helperMethods.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/BrandDivider.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/tourButton.dart';

class CollectPaymentDialog extends StatelessWidget {
  const CollectPaymentDialog(
      {Key? key, required this.paymentMethod, required this.fares})
      : super(key: key);

  final String paymentMethod;
  final int fares;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('${paymentMethod.toUpperCase()} PAYMENT'),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 16,
            ),
            Text(
              '\$$fares',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Brand-Bold',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Amount above is the total fares to be charged to the TOUR GUIDE',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 230,
              child: TourButtton(
                title: (paymentMethod == 'cash') ? 'COLLECT CASH' : 'CONFIRM',
                color: BrandColors.colorGreen,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  HelperMethods.enableHomeTabLocationUpdates();
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
