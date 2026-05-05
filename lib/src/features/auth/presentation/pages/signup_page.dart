import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_typography.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.length < 3 || email.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username min 3, password min 6, email wajib diisi.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      final user = response.user;
      if (user != null) {
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id,
          'email': user.email ?? email,
          'username': username,
          'bio': '',
          'role': 'user',
        });
      }

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text('ARSIVA', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 4, fontWeight: FontWeight.w700)),
              Text('GALLERY ART', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
              const SizedBox(height: 24),
              Text('Buat Akun', style: AppTypography.glyphic(fontSize: 34, color: Theme.of(context).textTheme.titleLarge?.color)),
              const SizedBox(height: 16),
              TextField(controller: _usernameController, style: const TextStyle(color: Colors.black, fontSize: 16), decoration: InputDecoration(hintText: 'Username', hintStyle: GoogleFonts.poppins(color: Colors.grey[400]))),
              const SizedBox(height: 12),
              TextField(controller: _emailController, style: const TextStyle(color: Colors.black, fontSize: 16), decoration: InputDecoration(hintText: 'Email', hintStyle: GoogleFonts.poppins(color: Colors.grey[400]))),
              const SizedBox(height: 12),
              TextField(controller: _passwordController, obscureText: true, style: const TextStyle(color: Colors.black, fontSize: 16), decoration: InputDecoration(hintText: 'Password', hintStyle: GoogleFonts.poppins(color: Colors.grey[400]))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('SIGN UP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
