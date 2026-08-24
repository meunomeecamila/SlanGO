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
  String get createAccount => 'Crear cuenta';

  @override
  String get startAdventureSubtitle =>
      '¡Comienza tu aventura en el universo de la jerga!';

  @override
  String get selectBirthDateError => 'Selecciona tu fecha de nacimiento.';

  @override
  String get selectSecurityQuestionError =>
      'Selecciona una pregunta de seguridad.';

  @override
  String get answerSecurityQuestionError =>
      'Responde la pregunta de seguridad.';

  @override
  String get termsTitle => 'Términos de responsabilidad';

  @override
  String get termsContent =>
      'Al aceptar, aceptas que tus datos puedan utilizarse con fines de investigación, análisis de datos y mejora de los servicios, respetando la privacidad y la seguridad de la información.';

  @override
  String get reject => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get termsAgreement =>
      'He leído y acepto los términos de uso y responsabilidad.';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get doLogin => 'Iniciar sesión';

  @override
  String get securityQuestionPet => '¿Cómo se llamaba tu primera mascota?';

  @override
  String get securityQuestionBirthCity => '¿En qué ciudad naciste?';

  @override
  String get securityQuestionMotherName => '¿Cómo se llama tu madre?';

  @override
  String get securityQuestionFirstSchool =>
      '¿Cómo se llamaba tu primera escuela?';

  @override
  String get securityQuestionFavoriteDish => '¿Cuál es tu plato favorito?';

  @override
  String get securityQuestionChildhoodFriend =>
      '¿Cómo se llamaba tu mejor amigo de la infancia?';

  @override
  String get worldStatusAvailable => 'Disponible';

  @override
  String get worldGamesDescription =>
      'Jerga que nace en las partidas online: del chat de la ranqueada a las bromas de la gente gamer.';

  @override
  String get worldKpopName => 'Mundo K-Pop';

  @override
  String get worldKpopDescription =>
      'El vocabulario de los fandoms coreanos: términos de fans, comebacks y expresiones que se usan en los grupos.';

  @override
  String get worldMakeupName => 'Mundo Maquillaje';

  @override
  String get worldMakeupDescription =>
      'Términos de belleza y maquillaje que dominan tutoriales, reseñas y la rutina de skincare.';

  @override
  String get worldPopName => 'Mundo Pop';

  @override
  String get worldPopDescription =>
      'Expresiones de la cultura pop: música, series, memes y todo lo que se pone de moda.';

  @override
  String get worldOldName => 'Mundo Retro';

  @override
  String get worldOldDescription =>
      'La jerga clásica de otras décadas, que los mayores todavía usan y sigue apareciendo por ahí.';

  @override
  String get worldDailyName => 'Mundo Cotidiano';

  @override
  String get worldDailyDescription =>
      'El habla del día a día: conversaciones en la calle, en la escuela y en casa, de forma informal.';

  @override
  String get worldSportsName => 'Mundo Deportes';

  @override
  String get worldSportsDescription =>
      'Jerga de cancha, campo y gradas: narración, hinchada y charla de entrenamiento.';

  @override
  String get worldGeekName => 'Mundo Geek';

  @override
  String get worldGeekDescription =>
      'El universo friki: animes, cómics, RPG y tecnología con su propio vocabulario.';

  @override
  String get worldSocialName => 'Mundo Redes Sociales';

  @override
  String get worldSocialDescription =>
      'El idioma de las líneas de tiempo: siglas, tendencias y expresiones que se vuelven virales cada semana.';

  @override
  String get worldRelationshipsName => 'Mundo Relaciones';

  @override
  String get worldRelationshipsDescription =>
      'Cómo la gente habla de conquistas, amistades y rupturas en las conversaciones de hoy.';

  @override
  String get worldCommunityName => 'Mundo De La Comunidad';

  @override
  String get worldCommunityDescription =>
      'El universo de la comunidad: términos, expresiones y conversaciones que unen a sus miembros.';

  @override
  String slangsLearnedProgress(int learned, int total) {
    return '$learned/$total jergas aprendidas';
  }

  @override
  String slangsToLearn(int total) {
    return '$total jergas por aprender';
  }

  @override
  String learnedOfTotal(int learned, int total) {
    return '$learned/$total aprendidas';
  }

  @override
  String get loadingTransmission => 'Cargando transmisión...';

  @override
  String get chooseModeTitle => 'Elige el Modo';

  @override
  String get chooseModeSubtitle => '¿Cómo quieres jugar esta fase?';

  @override
  String get casualModeLabel => 'Modo Casual (Solo Estudiar)';

  @override
  String get rankedModeLabel => 'Modo Clasificatorio (Con Tiempo)';

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

  @override
  String get noSlangsLearnedYet => 'Aún no has aprendido ninguna jerga.';

  @override
  String get errorLoadingLearnedSlangs =>
      'No se pudieron cargar las jergas aprendidas.';

  @override
  String get defaultUserName => 'Usuario';

  @override
  String get noItemsAvailable => 'Aún no hay objetos disponibles.';

  @override
  String get noWorldsAvailableYet => 'Aún no hay mundos disponibles.';

  @override
  String get trackWorldsProgress =>
      'Aquí puedes seguir el progreso de los mundos';

  @override
  String get noWorldsExploredYet =>
      'Aún no has explorado ningún mundo. ¡Comienza el viaje! 🚀';

  @override
  String get worldLockedMessage =>
      '¡Cuando el mundo llegue al 100%, vuelve aquí!';

  @override
  String get certificateUnlockedTapToOpen =>
      'Certificado desbloqueado: toca para abrir';

  @override
  String get certificateEarned => '¡Certificado obtenido! 🎉';

  @override
  String get downloadOfficialCertificate =>
      'Descargar certificado oficial (PDF)';

  @override
  String get downloadEtMessage => 'Descargar la notita de ETzinho (PDF)';

  @override
  String get pdfOpenError =>
      'No se pudo abrir el PDF. Comprueba que el archivo exista en assets/pdfs/.';

  @override
  String get noRankingRecordsFound =>
      'No se encontraron registros en la clasificación.';

  @override
  String get rankingIntro =>
      '¡Aquí está nuestra clasificación! Descubre quién ha aprendido más jerga y completado las rondas con los mejores tiempos.';

  @override
  String get noTimeRegisteredYet =>
      'Aún no tienes un tiempo registrado en la clasificación.';

  @override
  String get noTimedRoundYet => 'Aún no has completado una ronda cronometrada.';

  @override
  String get youLabel => 'TÚ';

  @override
  String percentExplored(int percent) {
    return '$percent% explorado';
  }

  @override
  String yourPosition(int position, int total) {
    return 'Tu posición: $position.º de $total';
  }

  @override
  String yourBestTime(String time) {
    return 'Tu mejor tiempo: $time';
  }

  @override
  String rankPositionBadge(int position) {
    return '$position.º';
  }
}
