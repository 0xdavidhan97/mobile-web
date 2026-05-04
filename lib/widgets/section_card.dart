import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  static const List<String> _labels = ['라이브', '속보', '미션', '시세조회', '툴박스', '비즈니스'];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Container(
      width: double.infinity,
      height: 118 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20 * s, 18 * s, 0, 0),
            child: Text(
              '주요 서비스',
              style: GoogleFonts.inter(
                fontSize: 14 * s,
                fontWeight: FontWeight.w700,
                height: 17 / 14,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 13 * s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _labels
                  .map((label) => _ServiceButton(label: label, s: s))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceButton extends StatelessWidget {
  final String label;
  final double s;

  const _ServiceButton({required this.label, required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42 * s,
          height: 42 * s,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFEFEFE),
                Color(0xFFF0F0F0),
                Color(0xFFFFFBFB),
              ],
              stops: [0.0, 0.6298, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10 * s),
          ),
        ),
        SizedBox(height: 5 * s),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9 * s,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6D6D6D),
          ),
        ),
      ],
    );
  }
}
