import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/supabase/supabase_bootstrap.dart';
import 'src/app.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseBootstrap.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(), 
    ),
  );
}