import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/supabase/supabase_bootstrap.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Text(
          'Something went wrong',
          style: const TextStyle(color: Colors.transparent),
        ),
      ),
    );
  };

  await SupabaseBootstrap.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
