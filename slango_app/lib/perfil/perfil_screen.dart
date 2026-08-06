// pagina que mostra o perfil

import 'package:flutter/material.dart';

import '../service/MundoService.dart';
import '../service/usuarioService.dart';
import '../user/User.dart';
import 'configuracoes.dart';
import 'progresso.dart';
import 'models.dart';
import 'cores.dart';
import 'texto.dart';
import 'background.dart';

enum _AbaPerfil { itens, certificados }

class PerfilScreen extends StatefulWidget {
  final String? nome;
  final String avatarAsset;
  final int totalMundos;
  final int totalGirias;
  final int totalCertificados;
  final List<ItemPerfil> itens;
  final List<CertificadoPerfil> certificados;

  const PerfilScreen({
    super.key,
    this.nome,
    this.avatarAsset = '',
    this.totalMundos = 0,
    this.totalGirias = 0,
    this.totalCertificados = 0,
    this.itens = const [],
    this.certificados = const [],
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  _AbaPerfil _abaAtual = _AbaPerfil.itens;
  Usuario? _usuario;
  List<ProgressoMundo> _mundosProgresso = [];
  late Future<void> _carregarPerfilFut;
  String? _erroPerfil;

  @override
  void initState() {
    super.initState();
    _carregarPerfilFut = _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final usuario = await UsuarioService.buscarUsuarioLogado();
      final mundosJson = await MundoService.obterProgressoMundos();

      final mundos = mundosJson.map<ProgressoMundo>((item) {
        final id = item['id']?.toString() ?? '';
        final quantidadeAprendida = item['quantidadeAprendida'] as int? ?? 0;
        final totalGirias = item['totalGirias'] as int? ?? 30;
        return ProgressoMundo(
          id: id,
          nome: _nomeDoMundo(id),
          girasAprendidas: quantidadeAprendida,
          totalGirias: totalGirias,
        );
      }).toList();

      if (mounted) {
        setState(() {
          _usuario = usuario;
          _mundosProgresso = mundos;
          _erroPerfil = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _erroPerfil = error.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  String _nomeDoMundo(String id) {
    const nomes = {
      'jogos': 'Mundo Jogos',
      'kpop': 'Mundo K-pop',
      'pop': 'Mundo Pop',
      'maquiagem': 'Mundo Maquiagem',
      'antigo': 'Mundo Antigo',
      'cotidiano': 'Mundo Cotidiano',
      'esportes': 'Mundo Esportes',
      'geek': 'Mundo Geek',
      'redessociais': 'Mundo Redes Sociais',
      'relacionamentos': 'Mundo Relacionamentos',
    };
    return nomes[id] ?? id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundEspaco(
        child: SafeArea(
          child: FutureBuilder<void>(
            future: _carregarPerfilFut,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_erroPerfil != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _erroPerfil!,
                      textAlign: TextAlign.center,
                      style: AppText.subtitulo(1),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  // Barra de topo: voltar pro mapa + ícones de configurações e progresso
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text("Mapa", style: AppText.subtitulo(1.1)),
            ],
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
          color: AppColors.card,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  // Card com avatar, nome e estatísticas (Mundos / Gírias / Certificados)
  Widget _buildCardAvatar() {
    final nome = _usuario?.nome ?? widget.nome ?? 'Usuário';
    final totalMundos = _mundosProgresso.isNotEmpty
        ? _mundosProgresso.length
        : widget.totalMundos;
    final totalGirias = _mundosProgresso.isNotEmpty
        ? _mundosProgresso.fold<int>(
            0,
            (sum, mundo) => sum + mundo.girasAprendidas,
          )
        : widget.totalGirias;
    final totalCertificados = _mundosProgresso
        .where((mundo) => mundo.progresso >= 1)
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cyan, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.45),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.avatarAsset.isNotEmpty
                      ? Image.asset(
                          widget.avatarAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.background,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.textSecondary,
                              size: 50,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                            size: 50,
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
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.background,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(nome, style: AppText.titulo(1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat(totalMundos.toString(), "Mundos"),
              _stat(totalGirias.toString(), "Gírias"),
              _stat(totalCertificados.toString(), "Certificados"),
            ],
          ),
        ],
      ),
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
              color: selecionada
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
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

  Widget _buildGridItens(List<ItemPerfil> lista) {
    if (lista.isEmpty) {
      return _vazio("Nenhum item por aqui ainda.");
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lista.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = lista[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: item.equipado
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.iconAsset,
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.star,
                  color: AppColors.textSecondary,
                  size: 28,
                ),
              ),
              if (item.equipado) ...[
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
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.emoji_events,
                      color: AppColors.cyan,
                      size: 32,
                    ),
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
