import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/banner_section.dart';
import '../widgets/info_card.dart';
import '../widgets/section_card.dart';
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
                  _SectionCardRow(child: const SectionCard(title: '주요 서비스', height: 136)),
                  _SectionCardRow(child: const SectionCard(title: '인기 검색 순위', height: 441)),
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
      padding: EdgeInsets.fromLTRB(12 * s, 0, 12 * s, 0),
      child: Row(
        children: [
          const InfoCard(title: '공포탐욕지수'),
          SizedBox(width: 14 * s),
          const InfoCard(title: '김치프리미엄'),
        ],
      ),
    );
  }
}

class _SectionCardRow extends StatelessWidget {
  final Widget child;
  const _SectionCardRow({required this.child});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Padding(
      padding: EdgeInsets.only(left: 12 * s, top: 13 * s),
      child: child,
    );
  }
}
