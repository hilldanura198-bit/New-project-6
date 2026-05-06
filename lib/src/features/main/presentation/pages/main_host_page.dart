import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../gallery/presentation/pages/gallery_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../../core/widgets/main_navigation.dart';

class MainHostPage extends ConsumerStatefulWidget {
  const MainHostPage({super.key});

  @override
  ConsumerState<MainHostPage> createState() => _MainHostPageState();
}

class _MainHostPageState extends ConsumerState<MainHostPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            HomePage(),
            GalleryPage(),
            _MainAiProxyPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() => _currentIndex = value),
      ),
    );
  }
}

class _MainAiProxyPage extends StatelessWidget {
  const _MainAiProxyPage();

  @override
  Widget build(BuildContext context) {
    return const _InlineAIAssistantPage();
  }
}

class _InlineAIAssistantPage extends StatefulWidget {
  const _InlineAIAssistantPage();

  @override
  State<_InlineAIAssistantPage> createState() => _InlineAIAssistantPageState();
}

class _InlineAIAssistantPageState extends State<_InlineAIAssistantPage> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  final List<_InlineMessage> _logs = [];
  String _model = 'GPT';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final q = (preset ?? _controller.text).trim();
    if (q.isEmpty) return;
    setState(() {
      _logs.add(_InlineMessage(isUser: true, text: q, model: _model));
      _logs.add(_InlineMessage(isUser: false, text: _answer(q), model: _model));
      _controller.clear();
    });
  }

  String _answer(String q) {
    final input = q.toLowerCase();
    const guard =
        'Saya fokus pada bantuan ARSIVA: galeri, koleksi karya, dan editing.';
    if (input.contains('edit') ||
        input.contains('filter') ||
        input.contains('crop')) {
      return 'Untuk hasil premium, mulai dari filter Soft, atur Exposure tipis, lalu crop 4:5 supaya fokus objek lebih kuat. $guard';
    }
    if (input.contains('galeri') ||
        input.contains('gallery') ||
        input.contains('trending')) {
      return 'Coba buka Gallery, gunakan search + kategori, lalu tandai karya dengan ikon hati untuk favorit. $guard';
    }
    if (input.contains('upload') || input.contains('scanner')) {
      return 'Upload ada di halaman Gallery. Scanner bisa dipakai untuk capture cepat sebelum masuk detail karya. $guard';
    }
    return 'Saya siap bantu kebutuhan seni dan penggunaan fitur ARSIVA. $guard';
  }

  void _onVoiceTap() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_rounded,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Voice Recorder Siap',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Ucapkan pertanyaan Anda tentang galeri atau editing ARSIVA.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mulai Rekam'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAttachImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (!mounted || image == null) return;
    setState(() {
      _logs.add(
        _InlineMessage(
          isUser: true,
          text: 'Mengunggah gambar: ${image.name}',
          model: _model,
        ),
      );
      _logs.add(
        _InlineMessage(
          isUser: false,
          text:
              'Gambar diterima. Saya siap bantu analisis warna, komposisi, dan langkah editing berikutnya.',
          model: _model,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final username =
        (user?.userMetadata?['username'] ??
                user?.email?.split('@').first ??
                'Collector')
            .toString();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      children: [
        if (_logs.isEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6933F5), Color(0xFF2C67FF)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(38),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Halo! Saya asisten AI ARSIVA. Apa yang ingin kamu buat hari ini?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0E4BB6), Color(0xFF5C8CFF)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            'Halo, $username! Ada yang bisa ARSIVA bantu hari ini?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask anything about art...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              IconButton(
                onPressed: _onAttachImage,
                icon: const Icon(Icons.attach_file_rounded),
              ),
              IconButton(
                onPressed: _onVoiceTap,
                icon: const Icon(Icons.mic_rounded),
              ),
              IconButton(
                onPressed: _send,
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _model = 'Meta');
                  _send('Tips kurasi galeri ARSIVA');
                },
                child: const Text('Meta'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _model = 'GPT');
                  _send('Analisis visual karya seni');
                },
                child: const Text('GPT'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _model = 'Gemini');
                  _send('Tips filter dan crop karya');
                },
                child: const Text('Gemini'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _promptChip('Bagaimana cara edit foto?'),
            _promptChip('Tampilkan galeri populer'),
            _promptChip('Tips pencahayaan karya'),
          ],
        ),
        const SizedBox(height: 12),
        ..._logs.reversed
            .take(10)
            .map(
              (e) => Align(
                alignment: e.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 320),
                  decoration: BoxDecoration(
                    gradient: e.isUser
                        ? const LinearGradient(
                            colors: [Color(0xFF7A33F9), Color(0xFF2A67FF)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFF2EEFF), Color(0xFFE1ECFF)],
                          ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.model} • ${e.isUser ? 'You' : 'ARSIVA AI'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: e.isUser
                              ? Colors.white70
                              : const Color(0xFF264074),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: e.isUser
                              ? Colors.white
                              : const Color(0xFF1A2C55),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _promptChip(String prompt) {
    return ActionChip(
      onPressed: () => _send(prompt),
      label: Text(prompt),
      avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
    );
  }
}

class _InlineMessage {
  const _InlineMessage({
    required this.isUser,
    required this.text,
    required this.model,
  });

  final bool isUser;
  final String text;
  final String model;
}
