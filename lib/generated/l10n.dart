// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Search notes`
  String get search {
    return Intl.message(
      'Search notes',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Enter tap to save task`
  String get task_hint {
    return Intl.message(
      'Enter tap to save task',
      name: 'task_hint',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message(
      'Done',
      name: 'Done',
      desc: '',
      args: [],
    );
  }

  /// `Set reminder`
  String get SetReminder {
    return Intl.message(
      'Set reminder',
      name: 'SetReminder',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get Completed {
    return Intl.message(
      'Completed',
      name: 'Completed',
      desc: '',
      args: [],
    );
  }

  /// `Write your first Note`
  String get emptyNote {
    return Intl.message(
      'Write your first Note',
      name: 'emptyNote',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get hintAddNote {
    return Intl.message(
      'Title',
      name: 'hintAddNote',
      desc: '',
      args: [],
    );
  }

  /// `Start typing`
  String get Starttyping {
    return Intl.message(
      'Start typing',
      name: 'Starttyping',
      desc: '',
      args: [],
    );
  }

  /// `Characters`
  String get Characters {
    return Intl.message(
      'Characters',
      name: 'Characters',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
