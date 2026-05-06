import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_username.text.trim().length < 3 || _email.text.trim().isEmpty || _password.text.length < 6) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signUp(email: _email.text.trim(), password: _password.text, data: {'username': _username.text.trim()});
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(builder: (_) => const LoginPage()), (route) => false);
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const LoginPage()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
          children: [
            Center(child: Text('ARSIVA GALLERY ART', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w800, letterSpacing: 1.5))),
            const SizedBox(height: 24),
            Text('Buat Akun', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: _username, decoration: const InputDecoration(hintText: 'Username')),
            const SizedBox(height: 10),
            TextField(controller: _email, decoration: const InputDecoration(hintText: 'Email')),
            const SizedBox(height: 10),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(hintText: 'Password')),
            const SizedBox(height: 14),
            SizedBox(height: 50, child: FilledButton(onPressed: _loading ? null : _signup, child: _loading ? const CircularProgressIndicator() : const Text('SIGN UP'))),
          ],
        ),
      ),
    );
  }
}
