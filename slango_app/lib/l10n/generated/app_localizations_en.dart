// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SlanGO';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get language => 'Language';

  @override
  String get general => 'General';

  @override
  String get security => 'Security';

  @override
  String get settings => 'Settings';

  @override
  String get name => 'Name';

  @override
  String get accountType => 'Account type';

  @override
  String get guardian => 'Guardian';

  @override
  String get youngPerson => 'Young person';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get selectDate => 'Select date';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saving => 'Saving...';

  @override
  String get noChanges => 'There are no changes to save.';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get changePassword => 'Change password';

  @override
  String get changeEmail => 'Change email';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get newEmail => 'New email';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountQuestion => 'Delete account?';

  @override
  String get deleteAccountDescription =>
      'This action is permanent and will erase all your progress.';

  @override
  String get delete => 'Delete';

  @override
  String get login => 'Log in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginWelcome =>
      'Continue your mission through the universe of slang!';

  @override
  String get forgotPassword => 'Forgot my password';

  @override
  String get recoverPassword => 'Recover password';

  @override
  String get searching => 'Searching...';

  @override
  String get searchSecurityQuestion => 'Find question';

  @override
  String get securityAnswer => 'Security answer';

  @override
  String get fillAllFields => 'Fill in all fields.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get passwordUpdated => 'Password updated successfully.';

  @override
  String get fillEmailAndPassword => 'Fill in email and password.';

  @override
  String get startMission => 'Start mission';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get loading => 'Loading...';

  @override
  String get tryAgain => 'Try again';

  @override
  String get errorSavingProgress =>
      'Could not save your progress. Check your connection.';

  @override
  String get rankingError =>
      'Could not add you to the ranking. Try again later.';

  @override
  String get suggestionSent => 'Suggestion sent! Our team will review it soon.';

  @override
  String get slangDeleted => 'Slang deleted successfully.';

  @override
  String get chooseRating => 'Choose a rating before sending';

  @override
  String get thanksFeedback => 'Thank you for your feedback!';

  @override
  String get confirm => 'Confirm';

  @override
  String get selectSecurityQuestion => 'Choose a question';

  @override
  String get chooseAvatar => 'Choose your avatar';

  @override
  String get progress => 'Progress';

  @override
  String get impactSentiment => 'Impact/sentiment';

  @override
  String get map => 'Map';

  @override
  String get worlds => 'Worlds';

  @override
  String get slangs => 'Slang';

  @override
  String get certificates => 'Certificates';

  @override
  String get items => 'Items';

  @override
  String get equipped => 'Equipped';

  @override
  String get ranking => 'Ranking';

  @override
  String get exploreNewWorlds => 'Explore new worlds';

  @override
  String get explorePlanet => 'Explore planet';

  @override
  String get locked => 'Locked';

  @override
  String get register => 'Sign up';

  @override
  String get guestLogin => 'Continue as guest';

  @override
  String get loggingIn => 'Signing in...';

  @override
  String get welcomeMessage =>
      'Learn slang from different communities and get closer to the people you love!';

  @override
  String questionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get noQuestionsFound => 'No questions found.';

  @override
  String errorLoadingQuiz(String error) {
    return 'Error loading quiz:\n$error';
  }

  @override
  String get noPhasesFound => 'No phases found.';

  @override
  String errorLoadingPhases(String error) {
    return 'Error loading phases: $error';
  }

  @override
  String get whyThisImpact => 'Why this impact?';

  @override
  String get correctFeedback => 'Correct! 🎉';

  @override
  String get incorrectFeedback => 'Incorrect!';

  @override
  String get keepGoingFeedback => 'Nice! Keep it up.';

  @override
  String correctAnswerWas(String answer) {
    return 'Answer: $answer';
  }

  @override
  String get resultPerfectTitle => 'Perfect, Astronaut!';

  @override
  String get resultGreatTitle => 'Congratulations, Astronaut!';

  @override
  String get resultGoodStartTitle => 'Good start, Astronaut! Let\'s improve';

  @override
  String get resultImproveTitle => 'Let\'s improve together, Astronaut!';

  @override
  String get resultPerfectMessage => 'You did amazingly on this journey!';

  @override
  String get resultGreatMessage => 'You did really well on this journey!';

  @override
  String get resultGoodEffortMessage =>
      'Good effort! Review the slang you missed and try again.';

  @override
  String get resultTryAgainMessage =>
      'Every journey starts with a single step. How about reviewing the lesson and trying again?';

  @override
  String worldName(String world) {
    return 'World $world';
  }

  @override
  String get correctAnswersLabel => 'Correct';

  @override
  String get wrongAnswersLabel => 'Wrong';

  @override
  String get timeLabel => 'Time';

  @override
  String performancePercentage(int percent) {
    return '$percent% performance';
  }

  @override
  String get identifyMeaning => 'Identify the meaning';

  @override
  String get meaningLabel => 'Meaning: ';

  @override
  String get usageExampleLabel => 'Usage example:';

  @override
  String get gotIt => 'Got it!';

  @override
  String get testYourKnowledge => 'Test your knowledge!';

  @override
  String get completeTheSentence => 'Complete the sentence:';

  @override
  String get finishWorld => 'Finish World 🏆';

  @override
  String get defaultWorldName => 'Games World';

  @override
  String get defaultReviewIntroMessage =>
      'Almost there! Shall we review what you learned?';

  @override
  String get appTagline => 'YOUR UNIVERSE OF SLANG';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startAdventureSubtitle =>
      'Start your adventure in the universe of slang!';

  @override
  String get selectBirthDateError => 'Select your date of birth.';

  @override
  String get selectSecurityQuestionError => 'Select a security question.';

  @override
  String get answerSecurityQuestionError => 'Answer the security question.';

  @override
  String get termsTitle => 'Terms of Responsibility';

  @override
  String get termsContent =>
      'By accepting, you agree that your data may be used for research purposes, data analysis, and service improvement, while respecting the privacy and security of your information.';

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Accept';

  @override
  String get termsAgreement =>
      'I have read and agree to the terms of use and responsibility.';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get doLogin => 'Log in';

  @override
  String get securityQuestionPet => 'What was the name of your first pet?';

  @override
  String get securityQuestionBirthCity => 'What city were you born in?';

  @override
  String get securityQuestionMotherName => 'What is your mother\'s name?';

  @override
  String get securityQuestionFirstSchool =>
      'What was the name of your first school?';

  @override
  String get securityQuestionFavoriteDish => 'What is your favorite dish?';

  @override
  String get securityQuestionChildhoodFriend =>
      'What was the name of your childhood best friend?';

  @override
  String get worldStatusAvailable => 'Available';

  @override
  String get worldGamesDescription =>
      'Slang born in online matches: from ranked chat to jokes among gamers.';

  @override
  String get worldKpopName => 'K-Pop World';

  @override
  String get worldKpopDescription =>
      'The vocabulary of Korean fandoms: fan terms, comebacks, and expressions used across groups.';

  @override
  String get worldMakeupName => 'Makeup World';

  @override
  String get worldMakeupDescription =>
      'Beauty and makeup terms that dominate tutorials, reviews, and skincare routines.';

  @override
  String get worldPopName => 'Pop World';

  @override
  String get worldPopDescription =>
      'Pop culture expressions: music, shows, memes, and everything trending right now.';

  @override
  String get worldOldName => 'Retro World';

  @override
  String get worldOldDescription =>
      'Classic slang from past decades that older generations still use today.';

  @override
  String get worldDailyName => 'Everyday World';

  @override
  String get worldDailyDescription =>
      'Everyday speech: conversations on the street, at school, and at home, the casual way.';

  @override
  String get worldSportsName => 'Sports World';

  @override
  String get worldSportsDescription =>
      'Slang from the court, the field, and the stands: commentary, cheering, and locker-room talk.';

  @override
  String get worldGeekName => 'Geek World';

  @override
  String get worldGeekDescription =>
      'The nerd universe: anime, comics, RPGs, and tech with their own vocabulary.';

  @override
  String get worldSocialName => 'Social Media World';

  @override
  String get worldSocialDescription =>
      'The language of timelines: acronyms, trends, and expressions that go viral every week.';

  @override
  String get worldRelationshipsName => 'Relationships World';

  @override
  String get worldRelationshipsDescription =>
      'How people talk about crushes, friendships, and breakups in today\'s conversations.';

  @override
  String get worldCommunityName => 'Community World';

  @override
  String get worldCommunityDescription =>
      'The community\'s universe: terms, expressions, and conversations that bring members together.';

  @override
  String slangsLearnedProgress(int learned, int total) {
    return '$learned/$total slang words learned';
  }

  @override
  String slangsToLearn(int total) {
    return '$total slang words to learn';
  }

  @override
  String learnedOfTotal(int learned, int total) {
    return '$learned/$total learned';
  }

  @override
  String get loadingTransmission => 'Loading transmission...';

  @override
  String get chooseModeTitle => 'Choose the Mode';

  @override
  String get chooseModeSubtitle => 'How do you want to play this phase?';

  @override
  String get casualModeLabel => 'Casual Mode (Just Study)';

  @override
  String get rankedModeLabel => 'Ranked Mode (Timed)';

  @override
  String get confirmSecurityQuestionFirst =>
      'Find the security question first.';

  @override
  String get profile => 'Profile';

  @override
  String get dontHaveAccountYet => 'Don\'t have an account yet? ';

  @override
  String certificateCongratsMessage(String name) {
    return 'Congratulations, $name!';
  }

  @override
  String certificateWorldConquered(String worldName) {
    return 'You conquered the $worldName World!';
  }

  @override
  String get itemUnlocked => 'Item unlocked:';

  @override
  String get certificateOfCompletion => 'CERTIFICATE OF COMPLETION';

  @override
  String get defaultAstronautName => 'Astronaut';
}
