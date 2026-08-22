import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'SlanGO'**
  String get appTitle;

  /// No description provided for @portuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In pt, this message translates to:
  /// **'Espanhol'**
  String get spanish;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @general.
  ///
  /// In pt, this message translates to:
  /// **'Geral'**
  String get general;

  /// No description provided for @security.
  ///
  /// In pt, this message translates to:
  /// **'Segurança'**
  String get security;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @accountType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de conta'**
  String get accountType;

  /// No description provided for @guardian.
  ///
  /// In pt, this message translates to:
  /// **'Responsável'**
  String get guardian;

  /// No description provided for @youngPerson.
  ///
  /// In pt, this message translates to:
  /// **'Jovem'**
  String get youngPerson;

  /// No description provided for @dateOfBirth.
  ///
  /// In pt, this message translates to:
  /// **'Data de nascimento'**
  String get dateOfBirth;

  /// No description provided for @selectDate.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar data'**
  String get selectDate;

  /// No description provided for @saveChanges.
  ///
  /// In pt, this message translates to:
  /// **'Salvar alterações'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In pt, this message translates to:
  /// **'Salvando...'**
  String get saving;

  /// No description provided for @noChanges.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma alteração para salvar.'**
  String get noChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Perfil atualizado com sucesso!'**
  String get profileUpdated;

  /// No description provided for @changePassword.
  ///
  /// In pt, this message translates to:
  /// **'Alterar senha'**
  String get changePassword;

  /// No description provided for @changeEmail.
  ///
  /// In pt, this message translates to:
  /// **'Alterar e-mail'**
  String get changeEmail;

  /// No description provided for @currentPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha atual'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In pt, this message translates to:
  /// **'Nova senha'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar nova senha'**
  String get confirmNewPassword;

  /// No description provided for @newEmail.
  ///
  /// In pt, this message translates to:
  /// **'Novo e-mail'**
  String get newEmail;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @signOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair da conta'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta'**
  String get deleteAccount;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In pt, this message translates to:
  /// **'Esta ação é permanente e apagará todo o seu progresso.'**
  String get deleteAccountDescription;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @login.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get login;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @loginWelcome.
  ///
  /// In pt, this message translates to:
  /// **'Continue sua missão pelo universo das gírias!'**
  String get loginWelcome;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get forgotPassword;

  /// No description provided for @recoverPassword.
  ///
  /// In pt, this message translates to:
  /// **'Recuperar senha'**
  String get recoverPassword;

  /// No description provided for @searching.
  ///
  /// In pt, this message translates to:
  /// **'Buscando...'**
  String get searching;

  /// No description provided for @searchSecurityQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Buscar pergunta'**
  String get searchSecurityQuestion;

  /// No description provided for @securityAnswer.
  ///
  /// In pt, this message translates to:
  /// **'Resposta de segurança'**
  String get securityAnswer;

  /// No description provided for @fillAllFields.
  ///
  /// In pt, this message translates to:
  /// **'Preencha todos os campos.'**
  String get fillAllFields;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não coincidem.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Senha atualizada com sucesso.'**
  String get passwordUpdated;

  /// No description provided for @fillEmailAndPassword.
  ///
  /// In pt, this message translates to:
  /// **'Preencha e-mail e senha.'**
  String get fillEmailAndPassword;

  /// No description provided for @startMission.
  ///
  /// In pt, this message translates to:
  /// **'Começar missão'**
  String get startMission;

  /// No description provided for @continueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get tryAgain;

  /// No description provided for @errorSavingProgress.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível salvar seu progresso. Verifique sua conexão.'**
  String get errorSavingProgress;

  /// No description provided for @rankingError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao registrar no ranking. Tente novamente mais tarde.'**
  String get rankingError;

  /// No description provided for @suggestionSent.
  ///
  /// In pt, this message translates to:
  /// **'Sugestão enviada! Em breve nossa equipe avaliará.'**
  String get suggestionSent;

  /// No description provided for @slangDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Gíria excluída com sucesso.'**
  String get slangDeleted;

  /// No description provided for @chooseRating.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma nota antes de enviar'**
  String get chooseRating;

  /// No description provided for @thanksFeedback.
  ///
  /// In pt, this message translates to:
  /// **'Obrigado pelo seu feedback!'**
  String get thanksFeedback;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @selectSecurityQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma pergunta'**
  String get selectSecurityQuestion;

  /// No description provided for @chooseAvatar.
  ///
  /// In pt, this message translates to:
  /// **'Escolha seu avatar'**
  String get chooseAvatar;

  /// No description provided for @progress.
  ///
  /// In pt, this message translates to:
  /// **'Progresso'**
  String get progress;

  /// No description provided for @impactSentiment.
  ///
  /// In pt, this message translates to:
  /// **'Impacto/sentimento'**
  String get impactSentiment;

  /// No description provided for @map.
  ///
  /// In pt, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @worlds.
  ///
  /// In pt, this message translates to:
  /// **'Mundos'**
  String get worlds;

  /// No description provided for @slangs.
  ///
  /// In pt, this message translates to:
  /// **'Gírias'**
  String get slangs;

  /// No description provided for @certificates.
  ///
  /// In pt, this message translates to:
  /// **'Certificados'**
  String get certificates;

  /// No description provided for @items.
  ///
  /// In pt, this message translates to:
  /// **'Itens'**
  String get items;

  /// No description provided for @equipped.
  ///
  /// In pt, this message translates to:
  /// **'Equipado'**
  String get equipped;

  /// No description provided for @ranking.
  ///
  /// In pt, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @exploreNewWorlds.
  ///
  /// In pt, this message translates to:
  /// **'Explore novos mundos'**
  String get exploreNewWorlds;

  /// No description provided for @explorePlanet.
  ///
  /// In pt, this message translates to:
  /// **'Explorar planeta'**
  String get explorePlanet;

  /// No description provided for @locked.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueado'**
  String get locked;

  /// No description provided for @register.
  ///
  /// In pt, this message translates to:
  /// **'Registrar'**
  String get register;

  /// No description provided for @guestLogin.
  ///
  /// In pt, this message translates to:
  /// **'Entrar sem login'**
  String get guestLogin;

  /// No description provided for @loggingIn.
  ///
  /// In pt, this message translates to:
  /// **'Entrando...'**
  String get loggingIn;

  /// No description provided for @welcomeMessage.
  ///
  /// In pt, this message translates to:
  /// **'Aprenda gírias de diversas comunidades para se aproximar de quem você ama!'**
  String get welcomeMessage;

  /// No description provided for @questionProgress.
  ///
  /// In pt, this message translates to:
  /// **'Pergunta {current} de {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @noQuestionsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma pergunta encontrada.'**
  String get noQuestionsFound;

  /// No description provided for @errorLoadingQuiz.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar quiz:\n{error}'**
  String errorLoadingQuiz(String error);

  /// No description provided for @noPhasesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma fase encontrada.'**
  String get noPhasesFound;

  /// No description provided for @errorLoadingPhases.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar fases: {error}'**
  String errorLoadingPhases(String error);

  /// No description provided for @whyThisImpact.
  ///
  /// In pt, this message translates to:
  /// **'Por que esse impacto?'**
  String get whyThisImpact;

  /// No description provided for @correctFeedback.
  ///
  /// In pt, this message translates to:
  /// **'Correto! 🎉'**
  String get correctFeedback;

  /// No description provided for @incorrectFeedback.
  ///
  /// In pt, this message translates to:
  /// **'Errado!'**
  String get incorrectFeedback;

  /// No description provided for @keepGoingFeedback.
  ///
  /// In pt, this message translates to:
  /// **'Boa! Continue assim.'**
  String get keepGoingFeedback;

  /// No description provided for @correctAnswerWas.
  ///
  /// In pt, this message translates to:
  /// **'Resposta: {answer}'**
  String correctAnswerWas(String answer);

  /// No description provided for @resultPerfectTitle.
  ///
  /// In pt, this message translates to:
  /// **'Perfeito, Astronauta!'**
  String get resultPerfectTitle;

  /// No description provided for @resultGreatTitle.
  ///
  /// In pt, this message translates to:
  /// **'Parabéns, Astronauta!'**
  String get resultGreatTitle;

  /// No description provided for @resultGoodStartTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bom começo, Astronauta! Vamos melhorar'**
  String get resultGoodStartTitle;

  /// No description provided for @resultImproveTitle.
  ///
  /// In pt, this message translates to:
  /// **'Vamos melhorar juntos, Astronauta!'**
  String get resultImproveTitle;

  /// No description provided for @resultPerfectMessage.
  ///
  /// In pt, this message translates to:
  /// **'Você mandou muito bem nessa jornada!'**
  String get resultPerfectMessage;

  /// No description provided for @resultGreatMessage.
  ///
  /// In pt, this message translates to:
  /// **'Você foi muito bem nessa jornada!'**
  String get resultGreatMessage;

  /// No description provided for @resultGoodEffortMessage.
  ///
  /// In pt, this message translates to:
  /// **'Bom esforço! Revise as gírias que errou e tente de novo.'**
  String get resultGoodEffortMessage;

  /// No description provided for @resultTryAgainMessage.
  ///
  /// In pt, this message translates to:
  /// **'Toda jornada começa com um passo. Que tal revisar a lição e tentar outra vez?'**
  String get resultTryAgainMessage;

  /// No description provided for @worldName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo {world}'**
  String worldName(String world);

  /// No description provided for @correctAnswersLabel.
  ///
  /// In pt, this message translates to:
  /// **'Acertos'**
  String get correctAnswersLabel;

  /// No description provided for @wrongAnswersLabel.
  ///
  /// In pt, this message translates to:
  /// **'Erros'**
  String get wrongAnswersLabel;

  /// No description provided for @timeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get timeLabel;

  /// No description provided for @performancePercentage.
  ///
  /// In pt, this message translates to:
  /// **'{percent}% de aproveitamento'**
  String performancePercentage(int percent);

  /// No description provided for @identifyMeaning.
  ///
  /// In pt, this message translates to:
  /// **'Identifique o significado'**
  String get identifyMeaning;

  /// No description provided for @meaningLabel.
  ///
  /// In pt, this message translates to:
  /// **'Significado: '**
  String get meaningLabel;

  /// No description provided for @usageExampleLabel.
  ///
  /// In pt, this message translates to:
  /// **'Exemplo de uso:'**
  String get usageExampleLabel;

  /// No description provided for @gotIt.
  ///
  /// In pt, this message translates to:
  /// **'Entendi!'**
  String get gotIt;

  /// No description provided for @testYourKnowledge.
  ///
  /// In pt, this message translates to:
  /// **'Teste seus conhecimentos!'**
  String get testYourKnowledge;

  /// No description provided for @completeTheSentence.
  ///
  /// In pt, this message translates to:
  /// **'Complete a frase:'**
  String get completeTheSentence;

  /// No description provided for @finishWorld.
  ///
  /// In pt, this message translates to:
  /// **'Concluir Mundo 🏆'**
  String get finishWorld;

  /// No description provided for @defaultWorldName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Jogos'**
  String get defaultWorldName;

  /// No description provided for @defaultReviewIntroMessage.
  ///
  /// In pt, this message translates to:
  /// **'Quase lá! Vamos revisar o que você aprendeu?'**
  String get defaultReviewIntroMessage;

  /// No description provided for @appTagline.
  ///
  /// In pt, this message translates to:
  /// **'SEU UNIVERSO DE GÍRIAS'**
  String get appTagline;

  /// No description provided for @createAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get createAccount;

  /// No description provided for @startAdventureSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Comece sua aventura no universo das gírias!'**
  String get startAdventureSubtitle;

  /// No description provided for @selectBirthDateError.
  ///
  /// In pt, this message translates to:
  /// **'Selecione sua data de nascimento.'**
  String get selectBirthDateError;

  /// No description provided for @selectSecurityQuestionError.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma pergunta de segurança.'**
  String get selectSecurityQuestionError;

  /// No description provided for @answerSecurityQuestionError.
  ///
  /// In pt, this message translates to:
  /// **'Responda a pergunta de segurança.'**
  String get answerSecurityQuestionError;

  /// No description provided for @termsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Termos de Responsabilidade'**
  String get termsTitle;

  /// No description provided for @termsContent.
  ///
  /// In pt, this message translates to:
  /// **'Ao aceitar, você concorda que seus dados poderão ser utilizados para fins de pesquisa, análise de dados e melhoria dos serviços, respeitando a privacidade e a segurança das informações.'**
  String get termsContent;

  /// No description provided for @reject.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitar'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In pt, this message translates to:
  /// **'Aceitar'**
  String get accept;

  /// No description provided for @termsAgreement.
  ///
  /// In pt, this message translates to:
  /// **'Li e concordo com os termos de uso e responsabilidade.'**
  String get termsAgreement;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já possui uma conta? '**
  String get alreadyHaveAccount;

  /// No description provided for @doLogin.
  ///
  /// In pt, this message translates to:
  /// **'Fazer Login'**
  String get doLogin;

  /// No description provided for @securityQuestionPet.
  ///
  /// In pt, this message translates to:
  /// **'Qual o nome do seu primeiro animal de estimação?'**
  String get securityQuestionPet;

  /// No description provided for @securityQuestionBirthCity.
  ///
  /// In pt, this message translates to:
  /// **'Qual o nome da cidade onde você nasceu?'**
  String get securityQuestionBirthCity;

  /// No description provided for @securityQuestionMotherName.
  ///
  /// In pt, this message translates to:
  /// **'Qual o nome da sua mãe?'**
  String get securityQuestionMotherName;

  /// No description provided for @securityQuestionFirstSchool.
  ///
  /// In pt, this message translates to:
  /// **'Qual foi o nome da sua primeira escola?'**
  String get securityQuestionFirstSchool;

  /// No description provided for @securityQuestionFavoriteDish.
  ///
  /// In pt, this message translates to:
  /// **'Qual é o seu prato favorito?'**
  String get securityQuestionFavoriteDish;

  /// No description provided for @securityQuestionChildhoodFriend.
  ///
  /// In pt, this message translates to:
  /// **'Qual o nome do seu melhor amigo de infância?'**
  String get securityQuestionChildhoodFriend;

  /// No description provided for @worldStatusAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Disponível'**
  String get worldStatusAvailable;

  /// No description provided for @worldGamesDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gírias que nascem nas partidas online: do chat da ranqueada às zoeiras da galera gamer.'**
  String get worldGamesDescription;

  /// No description provided for @worldKpopName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo K-Pop'**
  String get worldKpopName;

  /// No description provided for @worldKpopDescription.
  ///
  /// In pt, this message translates to:
  /// **'O vocabulário dos fandoms coreanos: termos de fã, comebacks e expressões que rolam nos grupos.'**
  String get worldKpopDescription;

  /// No description provided for @worldMakeupName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Maquiagem'**
  String get worldMakeupName;

  /// No description provided for @worldMakeupDescription.
  ///
  /// In pt, this message translates to:
  /// **'Termos de beleza e make que dominam tutoriais, resenhas e a rotina de skincare.'**
  String get worldMakeupDescription;

  /// No description provided for @worldPopName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Pop'**
  String get worldPopName;

  /// No description provided for @worldPopDescription.
  ///
  /// In pt, this message translates to:
  /// **'Expressões da cultura pop: música, séries, memes e tudo que vira assunto do momento.'**
  String get worldPopDescription;

  /// No description provided for @worldOldName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Antigo'**
  String get worldOldName;

  /// No description provided for @worldOldDescription.
  ///
  /// In pt, this message translates to:
  /// **'As gírias clássicas de outras décadas, que os mais velhos usam e ainda aparecem por aí.'**
  String get worldOldDescription;

  /// No description provided for @worldDailyName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Cotidiano'**
  String get worldDailyName;

  /// No description provided for @worldDailyDescription.
  ///
  /// In pt, this message translates to:
  /// **'O falar do dia a dia: conversas na rua, na escola e em casa, do jeitinho informal.'**
  String get worldDailyDescription;

  /// No description provided for @worldSportsName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Esportes'**
  String get worldSportsName;

  /// No description provided for @worldSportsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gírias de quadra, campo e arquibancada: narração, torcida e papo de treino.'**
  String get worldSportsDescription;

  /// No description provided for @worldGeekName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Geek'**
  String get worldGeekName;

  /// No description provided for @worldGeekDescription.
  ///
  /// In pt, this message translates to:
  /// **'Universo nerd: animes, quadrinhos, RPG e tecnologia com seu vocabulário próprio.'**
  String get worldGeekDescription;

  /// No description provided for @worldSocialName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Redes Sociais'**
  String get worldSocialName;

  /// No description provided for @worldSocialDescription.
  ///
  /// In pt, this message translates to:
  /// **'O idioma das timelines: siglas, trends e expressões que viralizam a cada semana.'**
  String get worldSocialDescription;

  /// No description provided for @worldRelationshipsName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Relacionamentos'**
  String get worldRelationshipsName;

  /// No description provided for @worldRelationshipsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Como a galera fala sobre paqueras, amizades e términos nas conversas de hoje.'**
  String get worldRelationshipsDescription;

  /// No description provided for @worldCommunityName.
  ///
  /// In pt, this message translates to:
  /// **'Mundo Da Comunidade'**
  String get worldCommunityName;

  /// No description provided for @worldCommunityDescription.
  ///
  /// In pt, this message translates to:
  /// **'O universo da comunidade: termos, expressões e conversas que unem os membros.'**
  String get worldCommunityDescription;

  /// No description provided for @slangsLearnedProgress.
  ///
  /// In pt, this message translates to:
  /// **'{learned}/{total} gírias aprendidas'**
  String slangsLearnedProgress(int learned, int total);

  /// No description provided for @slangsToLearn.
  ///
  /// In pt, this message translates to:
  /// **'{total} gírias para aprender'**
  String slangsToLearn(int total);

  /// No description provided for @learnedOfTotal.
  ///
  /// In pt, this message translates to:
  /// **'{learned}/{total} aprendidas'**
  String learnedOfTotal(int learned, int total);

  /// No description provided for @loadingTransmission.
  ///
  /// In pt, this message translates to:
  /// **'Carregando transmissão...'**
  String get loadingTransmission;

  /// No description provided for @chooseModeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o Modo'**
  String get chooseModeTitle;

  /// No description provided for @chooseModeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Como você deseja jogar essa fase?'**
  String get chooseModeSubtitle;

  /// No description provided for @casualModeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Modo Casual (Apenas Estudar)'**
  String get casualModeLabel;

  /// No description provided for @rankedModeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Modo Rankeado (Com Tempo)'**
  String get rankedModeLabel;
  /// No description provided for @confirmSecurityQuestionFirst.
  ///
  /// In pt, this message translates to:
  /// **'Busque a pergunta de segurança primeiro.'**
  String get confirmSecurityQuestionFirst;

  /// No description provided for @profile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @dontHaveAccountYet.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não possui uma conta? '**
  String get dontHaveAccountYet;

  /// No description provided for @certificateCongratsMessage.
  ///
  /// In pt, this message translates to:
  /// **'Parabéns, {name}!'**
  String certificateCongratsMessage(String name);

  /// No description provided for @certificateWorldConquered.
  ///
  /// In pt, this message translates to:
  /// **'Você conquistou o Mundo {worldName}!'**
  String certificateWorldConquered(String worldName);

  /// No description provided for @itemUnlocked.
  ///
  /// In pt, this message translates to:
  /// **'Item desbloqueado:'**
  String get itemUnlocked;

  /// No description provided for @certificateOfCompletion.
  ///
  /// In pt, this message translates to:
  /// **'CERTIFICADO DE CONCLUSÃO'**
  String get certificateOfCompletion;

  /// No description provided for @defaultAstronautName.
  ///
  /// In pt, this message translates to:
  /// **'Astronauta'**
  String get defaultAstronautName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
