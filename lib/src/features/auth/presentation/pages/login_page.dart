import 'dart:async';

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
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  StreamSubscription<AuthState>? _authSubscription;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final auth = Supabase.instance.client.auth;
    _authSubscription = auth.onAuthStateChange.listen((data) {
      if (!mounted) return;
      if (data.session != null) {
        _goToHome();
      }
    });
    if (auth.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _goToHome();
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainShellPage()),
      (route) => false,
    );
  }

  Future<void> _login() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _loginWithPhone() async {
    if (_phone.text.trim().isEmpty) return;
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        phone: _phone.text.trim(),
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Masukkan OTP'),
          content: TextField(
            controller: _otp,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Kode OTP'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                await Supabase.instance.client.auth.verifyOTP(
                  phone: _phone.text.trim(),
                  token: _otp.text.trim(),
                  type: OtpType.sms,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Verifikasi'),
            ),
          ],
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
          children: [
            Center(
              child: Text(
                'ARSIVA GALLERY ART',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF1657C0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Selamat Datang',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('LOGIN'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _loginWithGoogle,
                icon: const Icon(Icons.g_mobiledata_rounded),
                label: const Text('Login with Google'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _loginWithPhone,
                icon: const Icon(Icons.phone_rounded),
                label: const Text('Login with Phone Number'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SignupPage()),
              ),
              child: const Text('Belum punya akun? Sign Up'),
            ),
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
      bottomNavigationBar: MainNavigation(
        currentIndex: _index,
        onTap: (v) => setState(() => _index = v),
      ),
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
  final List<({bool isUser, String text})> _chat = [];

  void _onVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice record aktif. Silakan mulai bicara.'),
      ),
    );
  }

  void _onAttach() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload gambar aktif. Pilih gambar dari perangkat.'),
      ),
    );
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final q = (preset ?? _text.text).trim();
    if (q.isEmpty) return;
    setState(() {
      _chat.add((isUser: true, text: q));
      _chat.add((isUser: false, text: _generateReply(q)));
      _text.clear();
    });
  }

  String _generateReply(String question) {
    final q = question.toLowerCase();
    if (q.contains('edit') || q.contains('filter') || q.contains('crop')) {
      return 'Mulai dari filter Soft, naikkan Contrast tipis, lalu crop 4:5 agar fokus karya lebih kuat.';
    }
    if (q.contains('galeri') || q.contains('karya') || q.contains('trending')) {
      return 'Coba cek Home untuk karya unggulan lalu buka Gallery untuk eksplorasi karya klasik dan modern.';
    }
    return 'Siap, aku bantu semua hal seputar ARSIVA: galeri, profil, dan editing karya seni.';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 98),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            image: const DecorationImage(
              image: NetworkImage(
                'https://www.transparenttextures.com/patterns/cubes.png',
              ),
              fit: BoxFit.cover,
              opacity: .08,
            ),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFFDDE7FF),
                child: Icon(
                  Icons.chat_bubble_rounded,
                  size: 34,
                  color: Color(0xFF5F78F8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome to Chatty',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2A2D4A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Chat with ARSIVA AI untuk rekomendasi seni, ide kurasi, dan bantuan editing karya.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7C7C8E),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 180,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3565E9), Color(0xFF4EA5FF)],
                    ),
                  ),
                  child: TextButton(
                    onPressed: () => _send('Halo ARSIVA AI'),
                    child: Text(
                      'Start Chat',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ..._chat.map((m) {
          final isUser = m.isUser;
          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF2F60E7), Color(0xFF4AA4FF)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFEAF3FF), Color(0xFFDDEBFF)],
                      ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                m.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isUser ? Colors.white : const Color(0xFF2A2D4A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _text,
                  decoration: const InputDecoration(
                    hintText: 'Type message...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              IconButton(
                onPressed: _onAttach,
                icon: const Icon(
                  Icons.attach_file_rounded,
                  color: Color(0xFF3565E9),
                ),
              ),
              IconButton(
                onPressed: _onVoice,
                icon: const Icon(Icons.mic_rounded, color: Color(0xFF3565E9)),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF3565E9), Color(0xFF4EA5FF)],
                  ),
                ),
                child: IconButton(
                  onPressed: _send,
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
