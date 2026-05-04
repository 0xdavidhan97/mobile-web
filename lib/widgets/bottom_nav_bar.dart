import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

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
                _NavIcon(asset: 'assets/home.png', size: 25 * s),
                _NavIcon(asset: 'assets/community.png', size: 24 * s),
                _NavIcon(asset: 'assets/space.png', size: 25 * s),
                _NavIcon(asset: 'assets/clock.png', size: 25 * s),
                _NavIcon(asset: 'assets/invest.png', size: 25 * s),
              ],
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String asset;
  final double size;

  const _NavIcon({required this.asset, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Image.asset(asset, width: size, height: size),
    );
  }
}
