// pagina que mostra o perfil

import 'package:flutter/material.dart';

import 'configuracoes.dart';
import 'progresso.dart';
import 'models.dart';
import 'cores.dart';
import 'texto.dart';
import '../final/Particulas.dart';

enum _AbaPerfil { itens, certificados }

class PerfilScreen extends StatefulWidget {
  final String nome;
  final String avatarAsset;
  final int totalMundos;
  final int totalGirias;
  final int totalCertificados;
  final List<ItemPerfil> itens;
  final List<CertificadoPerfil> certificados;

  const PerfilScreen({
    super.key,
    required this.nome,
    required this.avatarAsset,
    required this.totalMundos,
    required this.totalGirias,
    required this.totalCertificados,
    this.itens = const [],
    this.certificados = const [],
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  _AbaPerfil _abaAtual = _AbaPerfil.itens;

  // Avatar atualmente selecionado (começa com o que vier do widget)
  late String _avatarAtual = widget.avatarAsset;

  // Opções de avatar disponíveis pro usuário escolher
  static const List<String> _assetsAvatares = [
    "images/astronautas/Astronauta_I.png",
    "images/astronautas/Astronauta_II.png",
    "images/astronautas/Astronauta_III.png",
    "images/astronautas/Astronauta_IV.png",
    "images/astronautas/Astronauta_V.png",
  ];

  // TODO: substituir por dados reais vindos do backend (girasAprendidas por
  // mundo). Por enquanto todos os mundos têm 30 gírias fixas e
  // girasAprendidas = 0.
  List<ProgressoMundo> get _mundosProgresso => const [
        ProgressoMundo(id: "jogos", nome: "Mundo Jogos", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "kpop", nome: "Mundo K-pop", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "maquiagem", nome: "Mundo Maquiagem", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "pop", nome: "Mundo Pop", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "antigas", nome: "Mundo Gírias Antigas", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "geek", nome: "Mundo Geek", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "redes_sociais", nome: "Mundo Redes Sociais", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "cotidiano", nome: "Mundo Cotidiano", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "esportes", nome: "Mundo Esportes", girasAprendidas: 0, totalGirias: 30),
        ProgressoMundo(id: "relacionamentos", nome: "Mundo Relacionamentos", girasAprendidas: 0, totalGirias: 30),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticulasFundo(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildCardAvatar(),
                const SizedBox(height: 20),
                _buildAbas(),
                const SizedBox(height: 16),
                _buildConteudoAba(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Barra de topo: voltar pro mapa (estilo pill, igual ao botão "Mundo Jogos")
  // + ícones de configurações e progresso
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, color: Color(0xFFB9A6E8), size: 14),
                SizedBox(width: 6),
                Text(
                  'Mapa',
                  style: TextStyle(
                    color: Color(0xFFB9A6E8),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            _iconButton(
              icon: Icons.bar_chart_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProgressoScreen(mundos: _mundosProgresso),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _iconButton(
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConfiguracoesScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF241A3D),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF6C4FC9).withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: Icon(icon, color: const Color(0xFFB9A6E8), size: 20),
      ),
    );
  }

  // Card com avatar, nome e estatísticas (Mundos / Gírias / Certificados)
  Widget _buildCardAvatar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _abrirSeletorDeAvatar,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF6C4FC9).withOpacity(0.7),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.45),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _avatarAtual,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.background,
                        child: const Icon(Icons.person, color: AppColors.textSecondary, size: 50),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 16, color: AppColors.background),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(widget.nome, style: AppText.titulo(1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat(widget.totalMundos.toString(), "Mundos"),
              _stat(widget.totalGirias.toString(), "Gírias"),
              _stat(widget.totalCertificados.toString(), "Certificados"),
            ],
          ),
        ],
      ),
    );
  }

  void _abrirSeletorDeAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Escolha seu avatar", style: AppText.titulo(0.9)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _assetsAvatares.map((asset) {
                  final selecionado = asset == _avatarAtual;
                  return InkWell(
                    onTap: () {
                      setState(() => _avatarAtual = asset);
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selecionado ? AppColors.cyan : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          asset,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 70,
                            height: 70,
                            color: AppColors.background,
                            child: const Icon(Icons.person, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _stat(String numero, String label) {
    return Column(
      children: [
        Text(numero, style: AppText.numero(1)),
        const SizedBox(height: 2),
        Text(label, style: AppText.subtitulo(0.85)),
      ],
    );
  }

  // Abas: Itens / Certificados
  Widget _buildAbas() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _aba("Itens", _AbaPerfil.itens),
          _aba("Certificados", _AbaPerfil.certificados),
        ],
      ),
    );
  }

  Widget _aba(String label, _AbaPerfil aba) {
    final selecionada = _abaAtual == aba;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _abaAtual = aba),
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selecionada ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppText.subtitulo(0.95).copyWith(
              color: selecionada ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: selecionada ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConteudoAba() {
    switch (_abaAtual) {
      case _AbaPerfil.itens:
        return _buildGridItens(widget.itens);
      case _AbaPerfil.certificados:
        return _buildGridCertificados(widget.certificados);
    }
  }

  // Assets fixos dos 13 itens desbloqueáveis (images/itens/).
  static const List<String> _assetsItens = [
    "images/itens/Antigo_carta.png",
    "images/itens/Antigo_Pena.png",
    "images/itens/Cotidiano_Despertador.png",
    "images/itens/Cotidiano_Travesseiro.png",
    "images/itens/Esporte_Bola.png",
    "images/itens/Esporte_Medalha.png",
    "images/itens/Geek_Robo.png",
    "images/itens/Jogos_Controle.png",
    "images/itens/Kpop_Bandeira.png",
    "images/itens/Maquiagem_Paleta.png",
    "images/itens/Pop_pipoca.png",
    "images/itens/Ralacionamento_Cupido.png",
    "images/itens/Redes_Celular.png",
  ];

  Widget _buildGridItens(List<ItemPerfil> lista) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _assetsItens.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final asset = _assetsItens[index];
        // Se o backend já mandou dados desse item (equipado etc.), casa pelo asset.
        final itemCorrespondente = lista.where((i) => i.iconAsset == asset).isNotEmpty
            ? lista.firstWhere((i) => i.iconAsset == asset)
            : null;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: (itemCorrespondente?.equipado ?? false)
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                asset,
                width: 70,
                height: 70,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.star, color: AppColors.textSecondary, size: 28),
              ),
              if (itemCorrespondente?.equipado ?? false) ...[
                const SizedBox(height: 8),
                Text(
                  "Equipado",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppText.cardSubtitulo(0.75).copyWith(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridCertificados(List<CertificadoPerfil> lista) {
    if (lista.isEmpty) {
      return _vazio("Nenhum certificado conquistado ainda.");
    }
    return Column(
      children: lista
          .map(
            (c) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset(
                    c.iconAsset,
                    width: 36,
                    height: 36,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.emoji_events, color: AppColors.cyan, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      c.nome,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppText.cardTitulo(0.9),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _vazio(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: AppText.subtitulo(1),
        ),
      ),
    );
  }
}