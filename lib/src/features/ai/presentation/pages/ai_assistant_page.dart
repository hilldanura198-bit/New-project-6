import 'package:flutter/material.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  String _activeModel = 'GPT';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final prompt = (preset ?? _controller.text).trim();
    if (prompt.isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(role: 'user', model: _activeModel, text: prompt),
      );
      _messages.add(
        _ChatMessage(
          role: 'assistant',
          model: _activeModel,
          text: _reply(prompt),
        ),
      );
      _controller.clear();
    });
  }

  String _reply(String prompt) {
    final q = prompt.toLowerCase();
    const guard =
        'Saya hanya membantu topik ARSIVA: galeri, karya seni, dan panduan editing.';
    if (q.contains('crop') || q.contains('filter') || q.contains('edit')) {
      return 'Gunakan menu Editing: pilih filter lembut lalu crop rasio 4:5 agar fokus karya tetap kuat. $guard';
    }
    if (q.contains('gallery') ||
        q.contains('galeri') ||
        q.contains('karya') ||
        q.contains('arsiva')) {
      return 'Di ARSIVA Anda bisa jelajahi Home/Gallery, simpan favorit, lalu buka detail karya untuk info artist dan kategori. $guard';
    }
    if (q.contains('seni') || q.contains('komposisi') || q.contains('warna')) {
      return 'Untuk membaca karya seni, mulai dari komposisi, kontras warna, dan arah cahaya. Saya bisa bantu analisis per karya. $guard';
    }
    return 'Pertanyaan di luar konteks ARSIVA tidak saya proses. $guard';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          children: [
            Text(
              'How can I help you today?',
              style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Featured Models',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _modelCard(context, 'Meta', 'Kurasi karya ARSIVA'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _modelCard(context, 'GPT', 'Analisis visual karya'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _modelCard(context, 'Gemini', 'Tips editing karya'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recent Activities',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (_messages.isEmpty)
              Text(
                'Belum ada aktivitas. Pilih model lalu kirim pertanyaan seni.',
                style: t.bodySmall,
              ),
            ..._messages.reversed
                .take(8)
                .map(
                  (m) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${m.model} • ${m.role == 'assistant' ? 'ARSIVA AI' : 'You'}',
                          style: t.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(m.text, style: t.bodyMedium),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _modelCard(BuildContext context, String label, String prompt) {
    final selected = _activeModel == label;
    return InkWell(
      onTap: () => setState(() => _activeModel = label),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withAlpha(24)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30,
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _activeModel = label);
                  _send(prompt);
                },
                child: const Text('Chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.role,
    required this.model,
    required this.text,
  });
  final String role;
  final String model;
  final String text;
}
