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
      color: const Color(0xFFF8D7DA),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Something went wrong.\n${details.exceptionAsString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF721C24), fontSize: 12),
          ),
        ),
      ),
    );
  };

  await SupabaseBootstrap.initialize();

  runApp(const ProviderScope(child: MyApp()));
}
