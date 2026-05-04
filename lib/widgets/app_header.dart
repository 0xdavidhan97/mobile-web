import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topPadding),
          SizedBox(
            height: 56 * s,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12 * s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/cobak_logo.png', width: 32 * s, height: 32 * s),
                  const Spacer(),
                  Image.asset('assets/search.png', width: 21 * s, height: 21 * s),
                  SizedBox(width: 19 * s),
                  Image.asset('assets/bell.png', width: 21 * s, height: 21 * s),
                  SizedBox(width: 19 * s),
                  Image.asset('assets/robot.png', width: 21 * s, height: 21 * s),
                  SizedBox(width: 19 * s),
                  Image.asset('assets/profile.png', width: 22 * s, height: 22 * s),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
