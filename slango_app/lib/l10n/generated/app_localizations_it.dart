// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'SlanGO';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get english => 'Inglese';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get italian => 'Italiano';

  @override
  String get language => 'Lingua';

  @override
  String get general => 'Generale';

  @override
  String get security => 'Sicurezza';

  @override
  String get settings => 'Impostazioni';

  @override
  String get name => 'Nome';

  @override
  String get accountType => 'Tipo di account';

  @override
  String get guardian => 'Responsabile';

  @override
  String get youngPerson => 'Giovane';

  @override
  String get dateOfBirth => 'Data di nascita';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get saving => 'Salvataggio...';

  @override
  String get noChanges => 'Non ci sono modifiche da salvare.';

  @override
  String get profileUpdated => 'Profilo aggiornato con successo!';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get changeEmail => 'Cambia email';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get confirmNewPassword => 'Conferma nuova password';

  @override
  String get newEmail => 'Nuova email';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get signOut => 'Esci dall\'account';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountQuestion => 'Eliminare l\'account?';

  @override
  String get deleteAccountDescription =>
      'Questa azione è permanente e cancellerà tutti i tuoi progressi.';

  @override
  String get delete => 'Elimina';

  @override
  String get login => 'Accedi';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginWelcome =>
      'Continua la tua missione nell\'universo dello slang!';

  @override
  String get forgotPassword => 'Ho dimenticato la password';

  @override
  String get recoverPassword => 'Recupera password';

  @override
  String get searching => 'Ricerca in corso...';

  @override
  String get searchSecurityQuestion => 'Cerca domanda';

  @override
  String get securityAnswer => 'Risposta di sicurezza';

  @override
  String get fillAllFields => 'Compila tutti i campi.';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono.';

  @override
  String get passwordUpdated => 'Password aggiornata con successo.';

  @override
  String get fillEmailAndPassword => 'Inserisci email e password.';

  @override
  String get startMission => 'Inizia missione';

  @override
  String get continueLabel => 'Continua';

  @override
  String get back => 'Indietro';

  @override
  String get loading => 'Caricamento...';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get errorSavingProgress =>
      'Impossibile salvare i tuoi progressi. Controlla la connessione.';

  @override
  String get rankingError =>
      'Impossibile aggiungerti alla classifica. Riprova più tardi.';

  @override
  String get suggestionSent =>
      'Suggerimento inviato! Il nostro team lo esaminerà a breve.';

  @override
  String get slangDeleted => 'Slang eliminato con successo.';

  @override
  String get chooseRating => 'Scegli una valutazione prima di inviare';

  @override
  String get thanksFeedback => 'Grazie per il tuo feedback!';

  @override
  String get confirm => 'Conferma';

  @override
  String get selectSecurityQuestion => 'Scegli una domanda';

  @override
  String get chooseAvatar => 'Scegli il tuo avatar';

  @override
  String get progress => 'Progresso';

  @override
  String get impactSentiment => 'Impatto/sentimento';

  @override
  String get map => 'Mappa';

  @override
  String get worlds => 'Mondi';

  @override
  String get slangs => 'Slang';

  @override
  String get certificates => 'Certificati';

  @override
  String get items => 'Oggetti';

  @override
  String get equipped => 'Equipaggiato';

  @override
  String get ranking => 'Classifica';

  @override
  String get exploreNewWorlds => 'Esplora nuovi mondi';

  @override
  String get explorePlanet => 'Esplora pianeta';

  @override
  String get locked => 'Bloccato';

  @override
  String get register => 'Registrati';

  @override
  String get guestLogin => 'Continua come ospite';

  @override
  String get loggingIn => 'Accesso in corso...';

  @override
  String get welcomeMessage =>
      'Impara lo slang di diverse comunità e avvicinati alle persone che ami!';

  @override
  String questionProgress(int current, int total) {
    return 'Domanda $current di $total';
  }

  @override
  String get noQuestionsFound => 'Nessuna domanda trovata.';

  @override
  String errorLoadingQuiz(String error) {
    return 'Errore nel caricamento del quiz:\n$error';
  }

  @override
  String get noPhasesFound => 'Nessuna fase trovata.';

  @override
  String errorLoadingPhases(String error) {
    return 'Errore nel caricamento delle fasi: $error';
  }

  @override
  String get whyThisImpact => 'Perché questo impatto?';

  @override
  String get correctFeedback => 'Corretto! 🎉';

  @override
  String get incorrectFeedback => 'Sbagliato!';

  @override
  String get keepGoingFeedback => 'Bene! Continua così.';

  @override
  String correctAnswerWas(String answer) {
    return 'Risposta: $answer';
  }

  @override
  String get resultPerfectTitle => 'Perfetto, Astronauta!';

  @override
  String get resultGreatTitle => 'Complimenti, Astronauta!';

  @override
  String get resultGoodStartTitle => 'Buon inizio, Astronauta! Miglioriamo';

  @override
  String get resultImproveTitle => 'Miglioriamo insieme, Astronauta!';

  @override
  String get resultPerfectMessage =>
      'Hai fatto un ottimo lavoro in questo viaggio!';

  @override
  String get resultGreatMessage =>
      'Te la sei cavata molto bene in questo viaggio!';

  @override
  String get resultGoodEffortMessage =>
      'Buon impegno! Ripassa lo slang che hai sbagliato e riprova.';

  @override
  String get resultTryAgainMessage =>
      'Ogni viaggio inizia con un passo. Che ne dici di ripassare la lezione e riprovare?';

  @override
  String worldName(String world) {
    return 'Mondo $world';
  }

  @override
  String get correctAnswersLabel => 'Corrette';

  @override
  String get wrongAnswersLabel => 'Errate';

  @override
  String get timeLabel => 'Tempo';

  @override
  String performancePercentage(int percent) {
    return '$percent% di rendimento';
  }

  @override
  String get identifyMeaning => 'Identifica il significato';

  @override
  String get meaningLabel => 'Significato: ';

  @override
  String get usageExampleLabel => 'Esempio d\'uso:';

  @override
  String get gotIt => 'Ho capito!';

  @override
  String get testYourKnowledge => 'Metti alla prova le tue conoscenze!';

  @override
  String get completeTheSentence => 'Completa la frase:';

  @override
  String get finishWorld => 'Completa Mondo 🏆';

  @override
  String get defaultWorldName => 'Mondo Giochi';

  @override
  String get defaultReviewIntroMessage =>
      'Ci siamo quasi! Ripassiamo cosa hai imparato?';

  @override
  String get appTagline => 'IL TUO UNIVERSO DI SLANG';

  @override
  String get createAccount => 'Crea account';

  @override
  String get startAdventureSubtitle =>
      'Inizia la tua avventura nell\'universo dello slang!';

  @override
  String get selectBirthDateError => 'Seleziona la tua data di nascita.';

  @override
  String get selectSecurityQuestionError =>
      'Seleziona una domanda di sicurezza.';

  @override
  String get answerSecurityQuestionError =>
      'Rispondi alla domanda di sicurezza.';

  @override
  String get termsTitle => 'Termini di responsabilità';

  @override
  String get termsContent =>
      'Accettando, acconsenti che i tuoi dati possano essere utilizzati per finalità di ricerca, analisi dei dati e miglioramento del servizio, nel rispetto della privacy e della sicurezza delle tue informazioni.';

  @override
  String get reject => 'Rifiuta';

  @override
  String get accept => 'Accetta';

  @override
  String get termsAgreement =>
      'Ho letto e accetto i termini di utilizzo e responsabilità.';

  @override
  String get alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get doLogin => 'Accedi';

  @override
  String get securityQuestionPet =>
      'Come si chiamava il tuo primo animale domestico?';

  @override
  String get securityQuestionBirthCity => 'In quale città sei nato/a?';

  @override
  String get securityQuestionMotherName => 'Come si chiama tua madre?';

  @override
  String get securityQuestionFirstSchool =>
      'Come si chiamava la tua prima scuola?';

  @override
  String get securityQuestionFavoriteDish => 'Qual è il tuo piatto preferito?';

  @override
  String get securityQuestionChildhoodFriend =>
      'Come si chiamava il tuo migliore amico d\'infanzia?';

  @override
  String get worldStatusAvailable => 'Disponibile';

  @override
  String get worldGamesDescription =>
      'Slang nato nelle partite online: dalla chat delle classificate alle battute tra gamer.';

  @override
  String get worldKpopName => 'Mondo K-Pop';

  @override
  String get worldKpopDescription =>
      'Il vocabolario dei fandom coreani: termini dei fan, comeback ed espressioni usate nei gruppi.';

  @override
  String get worldMakeupName => 'Mondo Make-up';

  @override
  String get worldMakeupDescription =>
      'Termini di bellezza e make-up che dominano tutorial, recensioni e routine di skincare.';

  @override
  String get worldPopName => 'Mondo Pop';

  @override
  String get worldPopDescription =>
      'Espressioni della cultura pop: musica, serie TV, meme e tutto ciò che è di tendenza ora.';

  @override
  String get worldOldName => 'Mondo Retrò';

  @override
  String get worldOldDescription =>
      'Slang classico di decenni passati, ancora usato oggi dalle generazioni più grandi.';

  @override
  String get worldDailyName => 'Mondo Quotidiano';

  @override
  String get worldDailyDescription =>
      'Il parlato di tutti i giorni: conversazioni per strada, a scuola e a casa, in modo informale.';

  @override
  String get worldSportsName => 'Mondo Sport';

  @override
  String get worldSportsDescription =>
      'Slang dal campo, dal terreno di gioco e dagli spalti: telecronaca, tifo e chiacchiere da spogliatoio.';

  @override
  String get worldGeekName => 'Mondo Geek';

  @override
  String get worldGeekDescription =>
      'L\'universo nerd: anime, fumetti, giochi di ruolo e tecnologia con il proprio vocabolario.';

  @override
  String get worldSocialName => 'Mondo Social Media';

  @override
  String get worldSocialDescription =>
      'Il linguaggio delle timeline: sigle, tendenze ed espressioni che diventano virali ogni settimana.';

  @override
  String get worldRelationshipsName => 'Mondo Relazioni';

  @override
  String get worldRelationshipsDescription =>
      'Come si parla di cotte, amicizie e rotture nelle conversazioni di oggi.';

  @override
  String get worldCommunityName => 'Mondo della Comunità';

  @override
  String get worldCommunityDescription =>
      'L\'universo della comunità: termini, espressioni e conversazioni che uniscono i membri.';

  @override
  String slangsLearnedProgress(int learned, int total) {
    return '$learned/$total slang imparati';
  }

  @override
  String slangsToLearn(int total) {
    return '$total slang da imparare';
  }

  @override
  String learnedOfTotal(int learned, int total) {
    return '$learned/$total imparati';
  }

  @override
  String get loadingTransmission => 'Caricamento trasmissione...';

  @override
  String get chooseModeTitle => 'Scegli la modalità';

  @override
  String get chooseModeSubtitle => 'Come vuoi giocare questa fase?';

  @override
  String get casualModeLabel => 'Modalità Casual (Solo studio)';

  @override
  String get rankedModeLabel => 'Modalità Classificata (A tempo)';

  @override
  String get confirmSecurityQuestionFirst =>
      'Cerca prima la domanda di sicurezza.';

  @override
  String get profile => 'Profilo';

  @override
  String get dontHaveAccountYet => 'Non hai ancora un account? ';

  @override
  String certificateCongratsMessage(String name) {
    return 'Complimenti, $name!';
  }

  @override
  String certificateWorldConquered(String worldName) {
    return 'Hai conquistato il Mondo $worldName!';
  }

  @override
  String get itemUnlocked => 'Oggetto sbloccato:';

  @override
  String get certificateOfCompletion => 'CERTIFICATO DI COMPLETAMENTO';

  @override
  String get defaultAstronautName => 'Astronauta';

  @override
  String get noSlangsLearnedYet => 'Nenhuma gíria aprendida ainda.';

  @override
  String get errorLoadingLearnedSlangs =>
      'Não foi possível carregar as gírias aprendidas.';

  @override
  String get defaultUserName => 'Usuário';

  @override
  String get noItemsAvailable => 'Nenhum item disponível ainda.';

  @override
  String get noWorldsAvailableYet => 'Nenhum mundo disponível ainda.';

  @override
  String get trackWorldsProgress => 'Acompanhe aqui o progresso dos mundos';

  @override
  String get noWorldsExploredYet =>
      'Nenhum mundo explorado ainda. Comece a viagem! 🚀';

  @override
  String get worldLockedMessage => 'Quando o mundo chegar a 100%, volte aqui!';

  @override
  String get certificateUnlockedTapToOpen =>
      'Certificado liberado — toque para abrir';

  @override
  String get certificateEarned => 'Certificado conquistado! 🎉';

  @override
  String get downloadOfficialCertificate => 'Baixar certificado oficial (PDF)';

  @override
  String get downloadEtMessage => 'Baixar recadinho do ETzinho (PDF)';

  @override
  String get pdfOpenError =>
      'Não foi possível abrir o PDF. Confira se o arquivo existe em assets/pdfs/.';

  @override
  String get noRankingRecordsFound => 'Nenhum registro encontrado no ranking.';

  @override
  String get rankingIntro =>
      'Aqui está o nosso ranking! Confira quem já aprendeu mais gírias e completou as rodadas com os melhores tempos.';

  @override
  String get noTimeRegisteredYet =>
      'Você ainda não tem um tempo registrado no ranking.';

  @override
  String get noTimedRoundYet =>
      'Você ainda não completou uma rodada cronometrada.';

  @override
  String get youLabel => 'VOCÊ';

  @override
  String percentExplored(int percent) {
    return '$percent% explorado';
  }

  @override
  String yourPosition(int position, int total) {
    return 'Sua posição: $position° de $total';
  }

  @override
  String yourBestTime(String time) {
    return 'Seu melhor tempo: $time';
  }

  @override
  String rankPositionBadge(int position) {
    return '$position°';
  }
}
