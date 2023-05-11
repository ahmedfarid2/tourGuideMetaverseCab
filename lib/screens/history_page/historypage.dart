import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';
import 'package:tour_guide_metaversecab/shared/data_provider/dataprovider.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/BrandDivider.dart';
import 'package:tour_guide_metaversecab/shared/reusable_components/HistoryTile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trip History',
        ),
        backgroundColor: BrandColors.colorPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return HistoryTile(
            history: Provider.of<AppData>(context).tripHistory[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => BrandDivider(),
        itemCount: Provider.of<AppData>(context).tripHistory.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
