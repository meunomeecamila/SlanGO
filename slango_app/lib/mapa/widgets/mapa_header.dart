import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/cores.dart';
import '../../feedback/feedback.dart';

class MapaHeader extends StatelessWidget {
  final VoidCallback? onPerfilTap;

  const MapaHeader({super.key, this.onPerfilTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Slan",
                      style: GoogleFonts.alfaSlabOne(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: "GO",
                      style: GoogleFonts.alfaSlabOne(
                        color: const Color(0xFF5EEAD4),
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                "Explore novos mundos",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeedbackPage(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primaryLight,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.feedback_outlined,
              color: AppColors.primaryLight,
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 12),

        GestureDetector(
          onTap: onPerfilTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primaryLight,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryLight,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}