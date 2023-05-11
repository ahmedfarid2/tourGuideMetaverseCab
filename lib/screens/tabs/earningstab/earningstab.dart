import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/screens/history_page/historypage.dart';
import 'package:tour_guide_metaversecab/shared/data_provider/dataprovider.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/BrandDivider.dart';

class EarningsTab extends StatelessWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$${Provider.of<AppData>(context).earnings}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryPage()));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/taxi.png',
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Trips',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      Provider.of<AppData>(context).tripCount.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BrandDivider(),
      ],
    );
  }
}
