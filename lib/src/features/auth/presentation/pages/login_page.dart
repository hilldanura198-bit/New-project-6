import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/main_navigation.dart';
import '../../../gallery/presentation/pages/gallery_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email dan password wajib diisi.')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const MainShellPage()),
        (route) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text('ARSIVA', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 4, fontWeight: FontWeight.w700)),
              Text('GALLERY ART', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
              const SizedBox(height: 32),
              Text('Selamat Datang', style: AppTypography.glyphic(fontSize: 34, color: Theme.of(context).textTheme.titleLarge?.color)),
              const SizedBox(height: 20),
              TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 12),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(hintText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('LOGIN'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SignupPage())),
                child: const Text("Don't have account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: const [
            HomePage(),
            GalleryPage(),
            _AiTab(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: MainNavigation(currentIndex: _index, onTap: (v) => setState(() => _index = v)),
    );
  }
}

class _AiTab extends StatefulWidget {
  const _AiTab();

  @override
  State<_AiTab> createState() => _AiTabState();
}

class _AiTabState extends State<_AiTab> {
  final _c = TextEditingController();
  final List<String> _items = [];
  String _model = 'GPT';

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final q = (text ?? _c.text).trim();
    if (q.isEmpty) return;
    setState(() {
      _items.add('$_model: $q');
      _items.add('ARSIVA AI: Saya hanya membantu topik galeri ARSIVA dan editing karya.');
      _c.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(controller: _c, decoration: const InputDecoration(hintText: 'Ask anything about art...')),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () { setState(() => _model='Meta'); _send('Tips kurasi galeri'); }, child: const Text('Meta'))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton(onPressed: () { setState(() => _model='GPT'); _send('Analisis karya'); }, child: const Text('GPT'))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton(onPressed: () { setState(() => _model='Gemini'); _send('Tips filter & crop'); }, child: const Text('Gemini'))),
        ]),
        const SizedBox(height: 12),
        ..._items.reversed.map((e) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)), child: Text(e))),
      ],
    );
  }
}
