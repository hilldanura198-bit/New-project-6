import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBootstrap {
  static Future<void> initialize() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || anonKey.isEmpty) {
      return;
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}
