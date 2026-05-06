import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(builder: (_) => const MainShellPage()), (route) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
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
            const SizedBox(height: 28),
            Text('Selamat Datang', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: _email, decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 10),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(hintText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
            const SizedBox(height: 14),
            SizedBox(height: 50, child: FilledButton(onPressed: _loading ? null : _login, child: _loading ? const CircularProgressIndicator() : const Text('LOGIN'))),
            const SizedBox(height: 10),
            SizedBox(height: 50, child: OutlinedButton.icon(onPressed: () async { await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google); }, icon: const Icon(Icons.g_mobiledata_rounded), label: const Text('LOGIN WITH GOOGLE'))),
            const SizedBox(height: 8),
            SizedBox(height: 50, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.phone_rounded), label: const Text('LOGIN WITH PHONE NUMBER'))),
            const SizedBox(height: 8),
            Text('Google login menggunakan akun Google Anda. Phone number login tersedia untuk verifikasi OTP.', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SignupPage())), child: const Text('Belum punya akun? Sign Up')),
          ],
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
            _AiChatPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: MainNavigation(currentIndex: _index, onTap: (v) => setState(() => _index = v)),
    );
  }
}

class _AiChatPage extends StatefulWidget {
  const _AiChatPage();

  @override
  State<_AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<_AiChatPage> {
  final _text = TextEditingController();
  final List<({String role, String model, String text})> _chat = [];
  String _provider = 'GPT';

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final q = (preset ?? _text.text).trim();
    if (q.isEmpty) return;
    final answer = _generateReply(q);
    setState(() {
      _chat.add((role: 'user', model: _provider, text: q));
      _chat.add((role: 'ai', model: _provider, text: answer));
      _text.clear();
    });
  }

  String _generateReply(String question) {
    final q = question.toLowerCase();
    const guard = 'Saya fokus membantu fitur galeri ARSIVA, scanner, upload, profil, dan editing karya.';
    if (q.contains('edit') || q.contains('filter') || q.contains('crop')) {
      return 'Coba mulai dari filter Soft lalu atur Contrast 1.1 dan Saturation 1.2 agar detail karya tetap natural. $guard';
    }
    if (q.contains('galeri') || q.contains('trending') || q.contains('karya')) {
      return 'Di halaman Home, cek section "Gallery Paling Trending". Di Gallery, gunakan search + scanner untuk eksplorasi lebih cepat. $guard';
    }
    if (q.contains('profil') || q.contains('akun')) {
      return 'Buka tab Profile untuk update data, avatar, dan pengaturan akun. Jika data tidak muncul, refresh profile dari halaman settings. $guard';
    }
    return 'Siap. $guard';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            _providerChip('Meta', Icons.public_rounded, const Color(0xFF4A63F2)),
            const SizedBox(width: 8),
            _providerChip('GPT', Icons.auto_awesome_rounded, const Color(0xFF16A085)),
            const SizedBox(width: 8),
            _providerChip('Gemini', Icons.diamond_rounded, const Color(0xFF8E44AD)),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: _chat.length,
            itemBuilder: (_, i) {
              final m = _chat[i];
              final user = m.role == 'user';
              return Align(
                alignment: user ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: user ? [const Color(0xFF4A63F2), const Color(0xFF1657C0)] : [const Color(0xFFEFF3FF), const Color(0xFFDDE7FF)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('${m.model}: ${m.text}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: user ? Colors.white : const Color(0xFF1A2B5C))),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
          child: Row(
            children: [
              Expanded(child: TextField(controller: _text, decoration: const InputDecoration(hintText: 'Ask anything about art...'))),
              const SizedBox(width: 8),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFE6ECFF),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_rounded, color: Color(0xFF1657C0), size: 22),
                  tooltip: 'Voice Recorder',
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _send,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF4A63F2), Color(0xFF1657C0)])),
                  child: const Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _providerChip(String name, IconData icon, Color color) {
    final selected = _provider == name;
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => setState(() => _provider = name),
      label: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: selected ? Colors.white : color), const SizedBox(width: 4), Text(name)]),
      selectedColor: color,
      labelStyle: TextStyle(color: selected ? Colors.white : color, fontWeight: FontWeight.w600),
    );
  }
}
