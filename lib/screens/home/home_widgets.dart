import 'package:flutter/material.dart';
import '../../utils/constants.dart';

////
////
////
//// Custom Box used on home screen
class CustomHomeBox extends StatelessWidget {
  const CustomHomeBox(
      {super.key,
      required this.title,
      required this.txtClr,
      required this.value,
      required this.boxClr,
      this.width,
      required this.onTap});
  final String title;
  final Color txtClr;
  final String value;
  final Color boxClr;
  final double? width;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 90,
        width: width ?? screenWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: boxClr,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: txtClr),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: txtClr),
            ),
          ],
        ),
      ),
    );
  }
}
