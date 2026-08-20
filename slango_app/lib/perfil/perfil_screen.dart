import 'package:flutter/material.dart';

import '../service/MundoService.dart';
import '../service/usuarioService.dart';
import '../service/perfilService.dart';
import '../service/rankService.dart';
import '../user/User.dart';
import 'certificados/aba_certificados.dart';
import 'configuracoes.dart';
import 'progresso.dart';
import 'widgets/moldura_rank.dart';
import 'models.dart';
import 'cores.dart';
import 'texto.dart';
import '../final/Particulas.dart';

enum _AbaPerfil { itens, certificados }

class PerfilScreen extends StatefulWidget {
  final String? nome;
  final int totalMundos;
  final int totalGirias;
  final int totalCertificados;
  final List<CertificadoPerfil> certificados;

  const PerfilScreen({
    super.key,
    this.nome,
    this.totalMundos = 0,
    this.totalGirias = 0,
    this.totalCertificados = 0,
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

  List<AstronautaPerfil> _astronautas = [];
  AstronautaPerfil? _astronautaAtual;
  bool _salvandoAvatar = false;

  List<ItemPerfil> _itens = [];
  int? _idItemEquipandoAgora;

  /// Posição do usuário no ranking global (1, 2, 3...). `null` = fora do ranking.
  /// Usada para decidir qual moldura de Top 3 exibir no avatar.
  int? _posicaoRank;

  @override
  void initState() {
    super.initState();
    _carregarPerfilFut = _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final resultados = await Future.wait([
        UsuarioService.buscarUsuarioLogado(),
        MundoService.obterProgressoMundos(),
        PerfilService.listarAstronautas(),
        PerfilService.listarItens(),
      ]);

      final usuario = resultados[0] as Usuario;
      final mundosJson = resultados[1] as List;
      final astronautas = resultados[2] as List<AstronautaPerfil>;
      final itens = resultados[3] as List<ItemPerfil>;

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

      AstronautaPerfil? astronautaSelecionado;
      if (astronautas.isNotEmpty) {
        astronautaSelecionado = astronautas.firstWhere(
          (a) => a.id == usuario.idAstronauta,
          orElse: () => astronautas.first,
        );
      }

      // Posição no ranking global (para a moldura de Top 3). Falha aqui não
      // deve quebrar o perfil, então tratamos o erro silenciosamente.
      int? posicaoRank;
      try {
        final ranking = await RankingService.buscarRankingGlobal();
        for (final item in ranking) {
          if (item.idUsuario == usuario.id) {
            posicaoRank = item.posicao;
            break;
          }
        }
      } catch (_) {
        posicaoRank = null;
      }

      if (mounted) {
        setState(() {
          _usuario = usuario;
          _mundosProgresso = mundos;
          _astronautas = astronautas;
          _astronautaAtual = astronautaSelecionado;
          _itens = itens;
          _posicaoRank = posicaoRank;
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
      'comunidade': 'Mundo Comunidade',
    };
    return nomes[id] ?? id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticulasFundo(
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
              icon: Icons.insights_rounded,
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

    final itemEquipado = _itens.cast<ItemPerfil?>().firstWhere(
      (item) => item?.equipado == true,
      orElse: () => null,
    );

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
            onTap: _astronautas.isEmpty ? null : _abrirSeletorDeAvatar,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ─── AVATAR + MOLDURA DE RANK (centralizada via AvatarComMoldura) ───
                AvatarComMoldura(
                  tamanhoAvatar: 110,
                  // <-- AJUSTE AQUI SE A MOLDURA FICAR GRANDE/PEQUENA DEMAIS
                  escalaMoldura: 1.75,
                  molduraPath: MolduraRank.caminhoParaPosicao(_posicaoRank),
                  avatar: Container(
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _astronautaAtual == null
                              ? Container(
                                  color: AppColors.background,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.textSecondary,
                                    size: 50,
                                  ),
                                )
                              : Image.network(
                                  _astronautaAtual!.urlAstronauta,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progresso) {
                                    if (progresso == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.background,
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.textSecondary,
                                      size: 50,
                                    ),
                                  ),
                                ),
                          if (itemEquipado != null)
                            Positioned(
                              bottom: 16,
                              left: -2,
                              child: Image.network(
                                itemEquipado.iconAsset,
                                width: 35,
                                height: 35,
                              ),
                            ),
                        ],
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

  void _abrirSeletorDeAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                    children: _astronautas.map((astronauta) {
                      final selecionado = astronauta.id == _astronautaAtual?.id;
                      return InkWell(
                        onTap: _salvandoAvatar
                            ? null
                            : () async {
                                setSheetState(() => _salvandoAvatar = true);
                                try {
                                  await PerfilService.atualizarAvatar(astronauta.id);
                                  if (!mounted) return;
                                  setState(() => _astronautaAtual = astronauta);
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        error.toString().replaceFirst('Exception: ', ''),
                                      ),
                                    ),
                                  );
                                } finally {
                                  setSheetState(() => _salvandoAvatar = false);
                                }
                              },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selecionado
                                  ? AppColors.cyan
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              astronauta.urlAstronauta,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 70,
                                height: 70,
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                ),
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
        return _buildGridItens();
      case _AbaPerfil.certificados:
        return AbaCertificados(
          mundos: _mundosProgresso,
          nomeUsuario: _usuario?.nome,
        );
    }
  }

  Future<void> _equiparItem(ItemPerfil item) async {
    if (!item.desbloqueado || _idItemEquipandoAgora != null) return;

    setState(() => _idItemEquipandoAgora = item.id);
    try {
      await PerfilService.equiparItem(item.id);
      if (!mounted) return;
      setState(() {
        _itens = _itens
            .map((i) => i.copyWith(equipado: i.id == item.id))
            .toList();
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _idItemEquipandoAgora = null);
    }
  }

  Widget _buildGridItens() {
    if (_itens.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            "Nenhum item disponível ainda.",
            style: AppText.subtitulo(1),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itens.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = _itens[index];
        final carregandoEsteItem = _idItemEquipandoAgora == item.id;

        return Opacity(
          opacity: item.desbloqueado ? 1.0 : 0.35,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: item.desbloqueado ? () => _equiparItem(item) : null,
            child: Container(
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        item.iconAsset,
                        width: 81,
                        height: 81,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.star,
                          color: AppColors.textSecondary,
                          size: 28,
                        ),
                      ),
                      if (carregandoEsteItem)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!item.desbloqueado)
                    const Icon(
                      Icons.lock,
                      size: 16,
                      color: AppColors.disabled,
                    )
                  else if (item.equipado)
                    Text(
                      "Equipado",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppText.cardSubtitulo(0.70).copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}