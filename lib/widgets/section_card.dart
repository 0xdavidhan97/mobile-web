import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final double height;
  final Widget? content;

  const SectionCard({
    super.key,
    required this.title,
    required this.height,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double s = screenWidth / 390;

    return Container(
      width: 365 * s,
      height: height * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      padding: EdgeInsets.fromLTRB(20 * s, 18 * s, 20 * s, 12 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14 * s,
              fontWeight: FontWeight.w600,
              height: 17 / 14,
              color: Colors.black,
            ),
          ),
          if (content != null) ...[
            SizedBox(height: 12 * s),
            content!,
          ],
        ],
      ),
    );
  }
}
