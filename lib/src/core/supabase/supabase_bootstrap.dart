import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBootstrap {
  static Future<void> initialize() async {
    const url = 'https://nubvdlvjldozeovkoxlh.supabase.co';
    const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51YnZkbHZqbGRvemVvdmtveGxoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc4MDM4MTgsImV4cCI6MjA5MzM3OTgxOH0.7c9ULG34mwWjyIK_hVpp3m27egGHddYKG1JrctUeglo';

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}