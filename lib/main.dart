import 'package:flutter/material.dart';
import 'package:my_dreams/app_widget.dart';
import 'package:my_dreams/shared/translate/translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await I18nTranslate.create(loader: TranslateLoader(basePath: 'assets/i18n'));

  runApp(const AppWidget());
}
