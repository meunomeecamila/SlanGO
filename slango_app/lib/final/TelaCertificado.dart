import 'package:flutter/material.dart';

import '../../mapa/models/mundo.dart';
import 'Particulas.dart';
import '../mapa/mapa.dart';
import '../perfil/perfil_screen.dart';




class TelaCertificado extends StatelessWidget {
  final Mundo mundo;
  final String? nomeUsuario;

  const TelaCertificado({
    super.key,
    required this.mundo,
    this.nomeUsuario,
  });

  String get _tratamento {
    final nome = (nomeUsuario ?? '').trim();
    return nome.isEmpty ? 'Astronauta' : nome;
  }

  static const Color backgroundDark = Color(0xff04011B);
  static const Color primaryPurple = Color(0xff7C5CFF);
  static const Color filledPurple = Color(0xff5D33D0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: ParticulasFundo(
        corParticulas: primaryPurple,
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              
              _Cabecalho(
                onMapaTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MapaScreen()),
                ),
                onPerfilTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    
                    
                    builder: (context) => const PerfilScreen(
                      totalMundos: 0,
                      totalGirias: 0,
                      totalCertificados: 0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              
              const Text(
                "🎉",
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                "Parabéns, $_tratamento!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Você conquistou o Mundo ${mundo.nome}!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 28),

              
              _CardCertificado(mundo: mundo),

              const SizedBox(height: 30),

              
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🎁 ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Item desbloqueado:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ItemDesbloqueadoFoto(
                    imagem: mundo.imagem,
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}




class _Cabecalho extends StatelessWidget {
  final VoidCallback onMapaTap;
  final VoidCallback onPerfilTap;

  const _Cabecalho({
    required this.onMapaTap,
    required this.onPerfilTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BotaoPilula(
          label: "Mapa",
          icon: Icons.arrow_back,
          onTap: onMapaTap,
        ),
        _BotaoPilula(
          label: "Perfil",
          trailingIcon: Icons.arrow_forward,
          onTap: onPerfilTap,
        ),
      ],
    );
  }
}

class _BotaoPilula extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  const _BotaoPilula({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF241A3D),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF6C4FC9).withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFFB9A6E8), size: 14),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFB9A6E8),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 6),
                Icon(trailingIcon, color: const Color(0xFFB9A6E8), size: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}




class _CardCertificado extends StatelessWidget {
  final Mundo mundo;

  const _CardCertificado({required this.mundo});

  @override
  Widget build(BuildContext context) {
    const Color cardBackground = Color(0xff120D31);
    const Color cardBorder = Color(0xff7C5CFF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardBackground,
            const Color(0xff1B1442),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cardBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cardBorder.withOpacity(0.3),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "CERTIFICADO DE CONCLUSÃO",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffB19CFF),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),

          
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                mundo.imagem,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.image, color: Colors.white24, size: 40),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            mundo.nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "SMURF · MVP · CLUTCH · FEED · NOOB",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.star_rounded,
                  color: Color(0xffFFD700),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class _ItemDesbloqueadoFoto extends StatelessWidget {
  final String imagem;

  const _ItemDesbloqueadoFoto({required this.imagem});

  @override
  Widget build(BuildContext context) {
    const Color cardBackground = Color(0xff120D31);
    const Color primaryPurple = Color(0xff7C5CFF);

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryPurple,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imagem,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_rounded,
              color: Color(0xffB19CFF),
              size: 28,
            );
          },
        ),
      ),
    );
  }
}