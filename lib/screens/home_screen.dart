import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/banner_section.dart';
import '../widgets/info_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BannerSection(),
                  _CardsRow(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const BottomNavBar(),
        ],
      ),
    );
  }
}

class _CardsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Padding(
      padding: EdgeInsets.fromLTRB(12 * s, 14 * s, 12 * s, 0),
      child: Row(
        children: [
          const InfoCard(title: '공포탐욕지수'),
          SizedBox(width: 14 * s),
          const InfoCard(title: ''),
        ],
      ),
    );
  }
}
