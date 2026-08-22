import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/l10n.dart';

class LogoSlango extends StatelessWidget {
  const LogoSlango({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Slan",
                style: GoogleFonts.alfaSlabOne(
                  fontSize: 50,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              TextSpan(
                text: "GO",
                style: GoogleFonts.alfaSlabOne(
                  fontSize: 54,
                  color: const Color(0xFF57E6D8),
                  height: 1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          context.l10n.appTagline,
          style: GoogleFonts.montserrat(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}