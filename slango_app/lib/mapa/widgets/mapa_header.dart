import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/cores.dart';

class MapaHeader extends StatelessWidget {
  const MapaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SlanGO",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.alfaSlabOne(
                  color: Colors.white,
                  fontSize: 32,
                ),
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

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                "5",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}