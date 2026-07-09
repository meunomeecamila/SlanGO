# Documentação de Requisitos do Sistema

##  Requisitos Funcionais (RF)

---

*   **RF 01 - Perfis de Usuário:** O sistema deve permitir a criação e diferenciação de perfis entre "Responsável" (Pai/Mãe) e "Filho/Filha", adaptando o fluxo do aplicativo para cada um.
*   **RF 02 - Avaliação de Conotação:** O sistema deve apresentar situações práticas (contexto) onde o usuário (Responsável) possa julgar se a aplicação de uma gíria tem conotação positiva ou negativa.
*   **RF 03 - Seleção de Interesses (Onboarding):** O sistema deve oferecer uma tela de configuração inicial para que o Responsável selecione os temas de gírias de maior interesse.
*   **RF 04 - Pular Onboarding:** O sistema deve disponibilizar um botão visível para pular a etapa de configuração de interesses (direcionado ao fluxo dos Filhos).
*   **RF 05 - Priorização de Conteúdo:** O sistema deve adaptar a ordem ou o destaque dos temas no mapa com base nas escolhas feitas durante o onboarding do Responsável.
*   **RF 06 - Mapa de Mundos:** O sistema deve exibir um mapa interativo contendo diferentes "mundos" temáticos de gírias disponíveis para exploração.
*   **RF 07 - Navegação Livre:** O sistema deve permitir que o perfil "Filho/Filha" navegue livremente e acesse qualquer mundo temático disponível no mapa, sem restrição de linearidade.
*   **RF 08 - Quizzes de Múltipla Escolha:** O sistema deve gerar perguntas de múltipla escolha sobre o significado e uso das gírias para testar o conhecimento do usuário.
*   **RF 09 - Feedback Explicativo:** O sistema deve exibir uma explicação detalhada sobre o significado e o contexto da gíria imediatamente após o usuário responder a uma pergunta do quiz.
*   **RF 10 - Sistema de Certificados:** O sistema deve gerar e armazenar no perfil do usuário um certificado digital sempre que ele concluir 100% de um "mundo" temático.
*   **RF 11 - Loja/Inventário de Cosméticos:** O sistema deve possuir um mecanismo de desbloqueio de itens cosméticos (roupas, acessórios, etc.) baseados no progresso ou pontuação do usuário nos quizzes.
*   **RF 12 - Personalização de Perfil:** O sistema deve permitir que o usuário customize sua identidade visual, alterando o avatar, paleta de cores e equipando os itens cosméticos desbloqueados.

---

##  Requisitos Não Funcionais (RNF)

---

*   **RNF 01 - Usabilidade e Design Inclusivo:** A interface deve ser clara e intuitiva para diferentes faixas etárias, utilizando elementos lúdicos e gamificados que engajem tanto adultos quanto adolescentes/crianças.
*   **RNF 02 - Desempenho e Feedback Imediato:** As transições entre as perguntas do quiz e a exibição das explicações de cada gíria devem ocorrer em tempo real (ex: menos de 1 segundo), mantendo a fluidez do jogo.
*   **RNF 03 - Retenção e Gamificação:** O design do mapa de mundos e a exibição de certificados e cosméticos desbloqueados devem utilizar gatilhos visuais de conquista (animações, sons) para estimular a competitividade saudável e a retenção do usuário.
*   **RNF 04 - Privacidade e Segurança (LGPD):** Como o aplicativo lida com perfis de menores de idade (Filhos), o sistema não deve coletar dados sensíveis desnecessários e deve garantir a privacidade das informações de jogo, vinculando-as de forma segura à conta do responsável.
*   **RNF 05 - Disponibilidade de Dados:** O progresso do usuário (certificados, itens cosméticos desbloqueados e personalizações de avatar) deve ser sincronizado em nuvem para que não seja perdido caso o usuário troque de dispositivo.
*   **RNF 06 - Acessibilidade Visual (Contraste e Fonte):** O sistema deve permitir que o usuário ajuste o tamanho das fontes e deve oferecer uma opção de "Modo de Alto Contraste" para facilitar a leitura por pessoas com baixa visão ou daltonismo.

>  **Atenção Front-End:** O requisito **RNF 06** é de extrema importância para a implementação da interface de usuário (UI).
