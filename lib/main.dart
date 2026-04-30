import 'package:flutter/widgets.dart';

import 'src/core/supabase/supabase_bootstrap.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initialize();
  runApp(const ArsivaApp());
}
