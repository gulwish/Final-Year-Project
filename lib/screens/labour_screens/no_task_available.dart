import 'package:flutter/material.dart';

import '/style/styling.dart';

class NoProductAvailable extends StatelessWidget {
  const NoProductAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Styling.navyBlue, borderRadius: BorderRadius.circular(8)),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24),
            Text(
              'This is where all your task offers are listed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Start adding your service offers by clicking on the add an ad button',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.2,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
