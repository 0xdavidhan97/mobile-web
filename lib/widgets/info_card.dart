import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final Widget? content;

  const InfoCard({
    super.key,
    required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;
    final double cardWidth = 160 * s;
    final double cardHeight = 99.19 * s;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      padding: EdgeInsets.all(12 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12 * s,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          if (content != null) ...[
            SizedBox(height: 8 * s),
            content!,
          ],
        ],
      ),
    );
  }
}
