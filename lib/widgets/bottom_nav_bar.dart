import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int activeIndex;

  const BottomNavBar({super.key, this.activeIndex = -1});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    final assets = [
      ('assets/home.png', 25.0),
      ('assets/community.png', 24.0),
      ('assets/space.png', 25.0),
      ('assets/clock.png', 25.0),
      ('assets/invest.png', 25.0),
    ];

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 52 * s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < assets.length; i++)
                  Opacity(
                    opacity: activeIndex == i ? 1.0 : 0.4,
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        assets[i].$1,
                        width: assets[i].$2 * s,
                        height: assets[i].$2 * s,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
