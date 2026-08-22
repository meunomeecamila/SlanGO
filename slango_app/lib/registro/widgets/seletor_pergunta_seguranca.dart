import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

/// Lista fixa de perguntas de segurança disponíveis para o usuário escolher
/// no cadastro. Usadas depois para recuperação de senha.
const List<String> perguntasDeSeguranca = [
  "Qual o nome do seu primeiro animal de estimação?",
  "Qual o nome da cidade onde você nasceu?",
  "Qual o nome da sua mãe?",
  "Qual foi o nome da sua primeira escola?",
  "Qual é o seu prato favorito?",
  "Qual o nome do seu melhor amigo de infância?",
];

/// Cor base "verde água" usada na caixa de pergunta e no ícone.
const Color _corVerdeAgua = Color(0xFF20C4B4);

/// Dropdown estilizado para escolher a pergunta de segurança no cadastro.
class SeletorPerguntaSeguranca extends StatelessWidget {
  final String? perguntaSelecionada;
  final ValueChanged<String?> onChanged;

  const SeletorPerguntaSeguranca({
    super.key,
    required this.perguntaSelecionada,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Mapa apenas para EXIBIÇÃO: a cada pergunta original (valor real,
    // usado no cadastro e na recuperação de senha) corresponde um texto
    // traduzido. O valor enviado para o backend continua sendo o texto
    // original em português, preservando a lógica existente.
    final Map<String, String> perguntasLocalizadas = {
      perguntasDeSeguranca[0]: l10n.securityQuestionPet,
      perguntasDeSeguranca[1]: l10n.securityQuestionBirthCity,
      perguntasDeSeguranca[2]: l10n.securityQuestionMotherName,
      perguntasDeSeguranca[3]: l10n.securityQuestionFirstSchool,
      perguntasDeSeguranca[4]: l10n.securityQuestionFavoriteDish,
      perguntasDeSeguranca[5]: l10n.securityQuestionChildhoodFriend,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _corVerdeAgua.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _corVerdeAgua,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: perguntaSelecionada,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: _corVerdeAgua),
          dropdownColor: const Color(0xFF241A3D),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: const Icon(Icons.help_outline, color: _corVerdeAgua),
            hintText: l10n.selectSecurityQuestion,
            hintStyle: const TextStyle(color: Colors.white54),
          ),
          items: perguntasDeSeguranca
              .map(
                (pergunta) => DropdownMenuItem<String>(
                  value: pergunta,
                  child: Text(
                    perguntasLocalizadas[pergunta] ?? pergunta,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (valor) =>
              valor == null ? l10n.selectSecurityQuestion : null,
        ),
      ),
    );
  }
}