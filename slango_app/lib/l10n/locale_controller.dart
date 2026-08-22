import 'package:flutter/material.dart';
import '../service/language_service.dart';

class LocaleController extends LanguageService {}

class LocaleControllerScope extends InheritedNotifier<LocaleController> {
  const LocaleControllerScope({
    required LocaleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleControllerScope>();
    assert(scope != null, 'LocaleControllerScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
