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
}