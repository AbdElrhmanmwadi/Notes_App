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

  /// `Sort`
  String get Sort {
    return Intl.message(
      'Sort',
      name: 'Sort',
      desc: '',
      args: [],
    );
  }

  /// `Huge`
  String get Huge {
    return Intl.message(
      'Huge',
      name: 'Huge',
      desc: '',
      args: [],
    );
  }

  /// `small`
  String get small {
    return Intl.message(
      'small',
      name: 'small',
      desc: '',
      args: [],
    );
  }

  /// `Large`
  String get Large {
    return Intl.message(
      'Large',
      name: 'Large',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get Medium {
    return Intl.message(
      'Medium',
      name: 'Medium',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get FontSize {
    return Intl.message(
      'Font Size',
      name: 'FontSize',
      desc: '',
      args: [],
    );
  }

  /// `Delete All data in App`
  String get DeletenotesinApp {
    return Intl.message(
      'Delete All data in App',
      name: 'DeletenotesinApp',
      desc: '',
      args: [],
    );
  }

  /// `APP SERVICES`
  String get APPSERVICES {
    return Intl.message(
      'APP SERVICES',
      name: 'APPSERVICES',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get Notes {
    return Intl.message(
      'Notes',
      name: 'Notes',
      desc: '',
      args: [],
    );
  }

  /// `Grid view`
  String get gridview {
    return Intl.message(
      'Grid view',
      name: 'gridview',
      desc: '',
      args: [],
    );
  }

  /// `List view`
  String get Listview {
    return Intl.message(
      'List view',
      name: 'Listview',
      desc: '',
      args: [],
    );
  }

  /// `layout`
  String get layout {
    return Intl.message(
      'layout',
      name: 'layout',
      desc: '',
      args: [],
    );
  }

  /// `By modification date`
  String get Bymodificationdate {
    return Intl.message(
      'By modification date',
      name: 'Bymodificationdate',
      desc: '',
      args: [],
    );
  }

  /// `By Creation date`
  String get ByCreationdate {
    return Intl.message(
      'By Creation date',
      name: 'ByCreationdate',
      desc: '',
      args: [],
    );
  }

  /// `STYLE`
  String get STYLE {
    return Intl.message(
      'STYLE',
      name: 'STYLE',
      desc: '',
      args: [],
    );
  }

  /// `Are your sure you want discard your changes ?`
  String get Areyour {
    return Intl.message(
      'Are your sure you want discard your changes ?',
      name: 'Areyour',
      desc: '',
      args: [],
    );
  }

  /// `Keep`
  String get Keep {
    return Intl.message(
      'Keep',
      name: 'Keep',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get Discard {
    return Intl.message(
      'Discard',
      name: 'Discard',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
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
