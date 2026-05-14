import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/banner_section.dart';
import '../widgets/info_card.dart';
import '../widgets/section_card.dart';
import '../widgets/ranking_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/theme_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeColorScope(
      color: '#FFFFFF',
      child: Scaffold(
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
                  _cardPadding(const ServiceCard()),
                  _cardPadding(const RankingCard()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const BottomNavBar(showSwipeBar: true),
        ],
        ),
      ),
    );
  }

  Widget _cardPadding(Widget child) {
    return Builder(
      builder: (context) {
        final double s = MediaQuery.of(context).size.width / 390;
        return Padding(
          padding: EdgeInsets.fromLTRB(12 * s, 13 * s, 12 * s, 0),
          child: child,
        );
      },
    );
  }
}

class _CardsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double s = MediaQuery.of(context).size.width / 390;

    return Padding(
      padding: EdgeInsets.fromLTRB(12 * s, 0, 12 * s, 0),
      child: Row(
        children: [
          const InfoCard(
            title: '공포탐욕지수',
            value: '40%',
            subtext: '공포',
            subtextColor: Color(0xFFFF6A0D),
          ),
          SizedBox(width: 14 * s),
          const InfoCard(
            title: '김치프리미엄',
            value: '0.26%',
            subtext: '정상',
            subtextColor: Color(0xFFFF3E0D),
          ),
        ],
      ),
    );
  }
}
