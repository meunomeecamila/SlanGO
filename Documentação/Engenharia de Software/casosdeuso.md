# Documentação de Casos de Uso

---

## Fluxo: Responsáveis

### Caso de Uso 01: Configurar Trilha de Aprendizado (Onboarding)
* **Ator Principal:** Responsável
* **Objetivo:** Escolher os temas de gírias de maior interesse para personalizar a exibição do mapa de mundos logo no primeiro acesso.
* **Pré-condições:** O Responsável deve ter criado uma conta e estar acessando o aplicativo pela primeira vez.

#### Fluxo Principal:
1. O sistema exibe a tela de boas-vindas e inicia o processo de configuração de interesses.
2. O sistema lista as categorias/temas de gírias disponíveis (ex: Gírias de Jogos, Gírias de Internet, Gírias Escolares).
3. O Responsável seleciona um ou mais temas que deseja aprender para se comunicar melhor com o filho.
4. O Responsável confirma a seleção.
5. O sistema processa as escolhas e gera o mapa de mundos, destacando e priorizando os temas selecionados logo no início da trilha.

* **Pós-condição:** O perfil do Responsável é atualizado no banco de dados com suas preferências. A etapa de onboarding é permanentemente marcada como concluída para este usuário, e o mapa de mundos fica disponível e personalizado para navegação.

---

### Caso de Uso 02: Avaliar Conotação e Aprender Gíria (Quiz)
* **Ator Principal:** Responsável
* **Objetivo:** Julgar se uma gíria tem impacto positivo ou negativo em uma situação real e receber a explicação do seu significado.
* **Pré-condições:** O Responsável deve estar logado e ter selecionado uma fase/nível dentro de um mundo temático no mapa.

#### Fluxo Principal:
1. O Responsável inicia um nível no mapa de mundos.
2. O sistema apresenta uma pergunta de múltipla escolha descrevendo uma situação hipotética (contexto) onde uma gíria é utilizada.
3. O sistema solicita que o Responsável identifique o significado ou julgue se a conotação daquela gíria na frase é positiva ou negativa.
4. O Responsável seleciona uma das opções de resposta e confirma.
5. O sistema valida a resposta em tempo real.
6. O sistema exibe um feedback visual e sonoro (acessível) indicando acerto ou erro.
7. O sistema exibe um quadro explicativo detalhando o significado real da gíria e como ela costuma ser aplicada.
8. O Responsável clica em "Continuar" para ir à próxima pergunta.

* **Pós-condição:** O progresso do usuário e a pontuação obtida na pergunta são salvos no sistema. O aplicativo segue para a próxima pergunta da fase ou avança para a tela de conclusão (caso tenha sido a última pergunta do nível).

---

### Caso de Uso 03: Obter Certificado de Conclusão de Mundo
* **Ator Principal:** Responsável
* **Objetivo:** Receber um certificado digital atestando o aprendizado após finalizar todas as etapas de um tema específico.
* **Pré-condições:** O Responsável deve estar respondendo ao último quiz do mundo temático atual.

#### Fluxo Principal:
1. O Responsável responde à última pergunta do mundo e clica em "Continuar".
2. O sistema calcula a pontuação total e verifica se o progresso atingiu 100% daquele tema.
3. O sistema exibe uma tela de celebração, com animações e efeitos sonoros/visuais.
4. O sistema gera um certificado digital personalizado com o nome do Responsável e o tema concluído.
5. O sistema salva automaticamente o certificado na aba de "Conquistas/Perfil" do usuário.
6. O sistema libera o Responsável para retornar ao mapa geral e escolher um novo mundo.

#### Fluxo Alternativo (Pontuação insuficiente):
* No passo 2, se o sistema exigir uma nota mínima para aprovação e o Responsável não atingir, o sistema exibe uma mensagem de incentivo, mostra os erros e sugere que o usuário refaça o quiz do mundo para obter o certificado. Neste caso, a pós-condição de sucesso não se aplica e o progresso fica pendente.

* **Pós-condição (Sucesso):** O "mundo" temático atual é sinalizado visualmente no mapa como 100% concluído. O certificado digital correspondente é atrelado permanentemente ao perfil do usuário e fica disponível para futura visualização.

---

## Fluxo: Filhos

### Caso de Uso 1 (Referente à HU2): Explorar Mundos Temáticos Livremente
* **Objetivo:** Este caso de uso descreve os passos para que o jogador navegue pelo mapa interativo do aplicativo e acesse, sem restrições de linearidade, qualquer mundo temático de seu interesse. O objetivo é permitir uma experiência de jogo autônoma e personalizada, baseada nas preferências do usuário.
* **Pré-condição:** O usuário deve estar autenticado no aplicativo e localizado na interface principal do Mapa de Mundos. Os mundos temáticos devem estar previamente carregados e habilitados no sistema.

#### Fluxo Principal:
1. O sistema apresenta o Mapa de Mundos, exibindo visualmente todas as regiões e temáticas disponíveis para exporação de forma interativa.
2. O usuário interage com o mapa (deslizando, dando zoom ou tocando) para analisar as opções de mundos disponíveis.
3. O usuário seleciona um mundo temático específico do seu interesse tocando no respectivo ícone ou nome.
4. O sistema processa a requisição e carrega os recursos visuais e os dados do mundo selecionado.
5. O sistema transita a interface, levando o usuário para a tela interna do mundo escolhido, exibindo as fases, atividades e quizzes contidos nele.

* **Pós-condição:** O usuário encontra-se dentro do ambiente do mundo selecionado, com todas as atividades pertinentes a esse tema disponíveis para iniciar.

---

### Caso de Uso 2 (Referente à HU3): Responder Quizzes de Gírias
* **Objetivo:** Detalha a interação do usuário ao iniciar e completar um quiz focado em gírias. O objetivo é testar os conhecimentos prévios do jogador e apresentar novos termos linguísticos através de um feedback educativo e em tempo real a cada resposta selecionada.
* **Pré-condição:** O usuário deve estar dentro de um mundo temático e ter selecionado uma atividade do tipo "Quiz". O banco de dados de perguntas e respostas deve estar operacional.

#### Fluxo Principal:
1. O usuário aciona o botão para iniciar um quiz de gírias disponível no mundo atual.
2. O sistema carrega as informações e exibe a primeira questão na tela, contendo o enunciado (a gíria) e as alternativas de resposta (os significados).
3. O usuário analisa as opções e toca na alternativa que julga ser a correta.
4. O sistema processa a escolha imediatamente e exibe um feedback na tela (destacando a resposta certa ou errada com cores/sons), além de fornecer uma breve explicação contextual sobre a gíria para consolidar o aprendizado.
5. O usuário toca no botão de avançar para ir à próxima pergunta.
6. Os passos 2 a 5 se repetem automaticamente até que todas as perguntas daquele bloco tenham sido respondidas.
7. O sistema compila os resultados e apresenta uma tela de resumo da partida, exibindo a pontuação final, quantidade de acertos, erros e as novas gírias aprendidas.

* **Pós-condição:** O progresso da fase é atualizado no perfil do usuário, e a pontuação obtida é registrada no banco de dados para o cálculo de futuras recompensas.

---

### Caso de Uso 3 (Referente à HU4): Desbloquear Itens Cosméticos e Completar Certificados
* **Objetivo:** Descreve o processo automático em que o sistema recompensa o jogador com itens cosméticos (para personalização) e certificados de conclusão ao atingir metas de desempenho. O objetivo é fomentar a retenção e fornecer um gatilho de engajamento competitivo para o usuário continuar jogando.
* **Pré-condição:** O usuário deve ter acabado de concluir um quiz ou um mundo inteiro com uma pontuação, ou taxa de acerto, igual ou superior à meta exigida pelas regras do jogo.

#### Fluxo Principal:
1. Imediatamente após a conclusão de uma atividade, o sistema avalia a pontuação final e o progresso acumulado do usuário.
2. O sistema verifica internamente que o usuário atingiu os pré-requisitos necessários (ex: 100% de acerto em um quiz ou conclusão de todas as fases de um tema) para receber uma premiação.
3. O sistema gera a recompensa apropriada (um novo item cosmético para o avatar ou um certificado temático de proficiência).
4. O sistema exibe uma animação e uma notificação de destaque na tela do usuário, anunciando formalmente a conquista.
5. O usuário interage com o botão de "Coletar" ou "Confirmar" para receber a recompensa.
6. O sistema atualiza o banco de dados, incluindo os novos prêmios à conta do jogador.

* **Pós-condição:** Os itens cosméticos recém-desbloqueados ficam imediatamente disponíveis para uso na tela de customização do avatar (inventário), e os certificados passam a constar na vitrine de conquistas do perfil do usuário de forma permanente.