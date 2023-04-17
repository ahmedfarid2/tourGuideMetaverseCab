import 'package:flutter/material.dart';
import 'package:tour_guide_metaversecab/brand_colors.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key? key, required this.status}) : super(key: key);
  static const String routeName = "login";
  final String status;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(
                width: 5.0,
              ),
              const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),
              ),
              const SizedBox(
                width: 25.0,
              ),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
