import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final List<String> _logs = [];
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
      _logs.add('$_model • You: $q');
      _logs.add('$_model • ARSIVA AI: Saya hanya menjawab soal galeri ARSIVA dan panduan editing karya.');
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      children: [
        Text('How can I help you today?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Ask anything about art...', prefixIcon: Icon(Icons.search_rounded)),
          onSubmitted: (_) => _send(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () { setState(() => _model = 'Meta'); _send('Tips kurasi galeri ARSIVA'); }, child: const Text('Meta'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: () { setState(() => _model = 'GPT'); _send('Analisis visual karya seni'); }, child: const Text('GPT'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: () { setState(() => _model = 'Gemini'); _send('Tips filter dan crop karya'); }, child: const Text('Gemini'))),
          ],
        ),
        const SizedBox(height: 12),
        ..._logs.reversed.take(10).map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
              child: Text(e, style: Theme.of(context).textTheme.bodyMedium),
            )),
      ],
    );
  }
}
