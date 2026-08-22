// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SlanGO';

  @override
  String get portuguese => 'Portugués';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get language => 'Idioma';

  @override
  String get general => 'General';

  @override
  String get security => 'Seguridad';

  @override
  String get settings => 'Configuración';

  @override
  String get name => 'Nombre';

  @override
  String get accountType => 'Tipo de cuenta';

  @override
  String get guardian => 'Responsable';

  @override
  String get youngPerson => 'Joven';

  @override
  String get dateOfBirth => 'Fecha de nacimiento';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get saving => 'Guardando...';

  @override
  String get noChanges => 'No hay cambios para guardar.';

  @override
  String get profileUpdated => '¡Perfil actualizado correctamente!';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get changeEmail => 'Cambiar correo electrónico';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get newEmail => 'Nuevo correo electrónico';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountQuestion => '¿Eliminar cuenta?';

  @override
  String get deleteAccountDescription =>
      'Esta acción es permanente y borrará todo tu progreso.';

  @override
  String get delete => 'Eliminar';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get loginWelcome => '¡Continúa tu misión por el universo de la jerga!';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get recoverPassword => 'Recuperar contraseña';

  @override
  String get searching => 'Buscando...';

  @override
  String get searchSecurityQuestion => 'Buscar pregunta';

  @override
  String get securityAnswer => 'Respuesta de seguridad';

  @override
  String get fillAllFields => 'Completa todos los campos.';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden.';

  @override
  String get passwordUpdated => '¡Contraseña actualizada correctamente!';

  @override
  String get fillEmailAndPassword =>
      'Completa el correo electrónico y la contraseña.';

  @override
  String get startMission => 'Comenzar misión';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get back => 'Volver';

  @override
  String get loading => 'Cargando...';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get errorSavingProgress =>
      'No se pudo guardar tu progreso. Comprueba tu conexión.';

  @override
  String get rankingError =>
      'No se pudo registrar en el ranking. Inténtalo más tarde.';

  @override
  String get suggestionSent =>
      '¡Sugerencia enviada! Nuestro equipo la evaluará pronto.';

  @override
  String get slangDeleted => 'Jerga eliminada correctamente.';

  @override
  String get chooseRating => 'Elige una calificación antes de enviar';

  @override
  String get thanksFeedback => '¡Gracias por tus comentarios!';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectSecurityQuestion => 'Elige una pregunta';

  @override
  String get chooseAvatar => 'Elige tu avatar';

  @override
  String get progress => 'Progreso';

  @override
  String get impactSentiment => 'Impacto/sentimiento';

  @override
  String get map => 'Mapa';

  @override
  String get worlds => 'Mundos';

  @override
  String get slangs => 'Jerga';

  @override
  String get certificates => 'Certificados';

  @override
  String get items => 'Objetos';

  @override
  String get equipped => 'Equipado';

  @override
  String get ranking => 'Clasificación';

  @override
  String get exploreNewWorlds => 'Explora nuevos mundos';

  @override
  String get explorePlanet => 'Explorar planeta';

  @override
  String get locked => 'Bloqueado';

  @override
  String get register => 'Registrar';

  @override
  String get guestLogin => 'Entrar sin cuenta';

  @override
  String get loggingIn => 'Entrando...';

  @override
  String get welcomeMessage =>
      '¡Aprende jerga de diversas comunidades y acércate a las personas que amas!';

  @override
  String questionProgress(int current, int total) {
    return 'Pregunta $current de $total';
  }

  @override
  String get noQuestionsFound => 'No se encontraron preguntas.';

  @override
  String errorLoadingQuiz(String error) {
    return 'Error al cargar el quiz:\n$error';
  }

  @override
  String get noPhasesFound => 'No se encontraron fases.';

  @override
  String errorLoadingPhases(String error) {
    return 'Error al cargar las fases: $error';
  }

  @override
  String get whyThisImpact => '¿Por qué este impacto?';

  @override
  String get correctFeedback => '¡Correcto! 🎉';

  @override
  String get incorrectFeedback => '¡Incorrecto!';

  @override
  String get keepGoingFeedback => '¡Bien! Sigue así.';

  @override
  String correctAnswerWas(String answer) {
    return 'Respuesta: $answer';
  }

  @override
  String get resultPerfectTitle => '¡Perfecto, Astronauta!';

  @override
  String get resultGreatTitle => '¡Felicidades, Astronauta!';

  @override
  String get resultGoodStartTitle =>
      '¡Buen comienzo, Astronauta! Vamos a mejorar';

  @override
  String get resultImproveTitle => '¡Vamos a mejorar juntos, Astronauta!';

  @override
  String get resultPerfectMessage => '¡Lo hiciste increíble en este viaje!';

  @override
  String get resultGreatMessage => '¡Te fue muy bien en este viaje!';

  @override
  String get resultGoodEffortMessage =>
      '¡Buen esfuerzo! Repasa la jerga que fallaste e inténtalo de nuevo.';

  @override
  String get resultTryAgainMessage =>
      'Todo viaje comienza con un paso. ¿Qué tal repasar la lección e intentarlo de nuevo?';

  @override
  String worldName(String world) {
    return 'Mundo $world';
  }

  @override
  String get correctAnswersLabel => 'Aciertos';

  @override
  String get wrongAnswersLabel => 'Errores';

  @override
  String get timeLabel => 'Tiempo';

  @override
  String performancePercentage(int percent) {
    return '$percent% de rendimiento';
  }

  @override
  String get identifyMeaning => 'Identifica el significado';

  @override
  String get meaningLabel => 'Significado: ';

  @override
  String get usageExampleLabel => 'Ejemplo de uso:';

  @override
  String get gotIt => '¡Entendido!';

  @override
  String get testYourKnowledge => '¡Pon a prueba tus conocimientos!';

  @override
  String get completeTheSentence => 'Completa la frase:';

  @override
  String get finishWorld => 'Finalizar Mundo 🏆';

  @override
  String get defaultWorldName => 'Mundo Juegos';

  @override
  String get defaultReviewIntroMessage =>
      '¡Ya casi! ¿Repasamos lo que aprendiste?';

  @override
  String get appTagline => 'TU UNIVERSO DE JERGA';
  @override
  String get confirmSecurityQuestionFirst =>
      'Busca primero la pregunta de seguridad.';

  @override
  String get profile => 'Perfil';

  @override
  String get dontHaveAccountYet => '¿Aún no tienes una cuenta? ';

  @override
  String certificateCongratsMessage(String name) {
    return '¡Felicidades, $name!';
  }

  @override
  String certificateWorldConquered(String worldName) {
    return '¡Conquistaste el Mundo $worldName!';
  }

  @override
  String get itemUnlocked => 'Objeto desbloqueado:';

  @override
  String get certificateOfCompletion => 'CERTIFICADO DE FINALIZACIÓN';

  @override
  String get defaultAstronautName => 'Astronauta';
}