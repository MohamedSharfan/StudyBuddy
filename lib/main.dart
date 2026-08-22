import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/study_buddy_app.dart';
import 'src/core/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnvironment.bootstrap();

  runApp(const ProviderScope(child: StudyBuddyApp()));
}
