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

  void _sendFromModel(String model, [String? preset]) {
    final prompt = (preset ?? _controller.text).trim();
    if (prompt.isEmpty) return;

    setState(() {
      _activeModel = model;
      _messages.add(_ChatMessage(role: 'user', model: model, text: prompt));
      _messages.add(
        _ChatMessage(
          role: 'assistant',
          model: model,
          text: _artFocusedReply(prompt, model),
        ),
      );
      _controller.clear();
    });
  }

  String _artFocusedReply(String prompt, String model) {
    final lower = prompt.toLowerCase();
    const guardrail =
        'Saya fokus pada konteks ARSIVA: konsep seni, referensi karya galeri, dan panduan editing artwork di aplikasi.';

    if (lower.contains('warna') ||
        lower.contains('editing') ||
        lower.contains('filter')) {
      return '[$model] Untuk editing karya: mulai dari exposure +10, contrast +8, saturation +6 agar detail tetap natural. $guardrail';
    }
    if (lower.contains('galeri') ||
        lower.contains('arsiva') ||
        lower.contains('karya')) {
      return '[$model] Di ARSIVA, Anda bisa jelajahi karya dari Home/Gallery, simpan favorit, lalu buka detail untuk insight medium, artist, dan tahun. $guardrail';
    }
    if (lower.contains('seni') || lower.contains('art')) {
      return '[$model] Konsep seni yang relevan: komposisi, pencahayaan, perspektif, dan narasi visual. Saya bisa bantu breakdown per karya di ARSIVA. $guardrail';
    }

    return '[$model] $guardrail Coba tanya tentang: referensi karya, kurasi galeri, atau langkah editing foto karya.';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                children: [
                  Text(
                    'How can I help you today?',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SearchComposer(
                    controller: _controller,
                    onSubmit: () => _sendFromModel(_activeModel),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Featured Models',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ModelButton(
                          label: 'Meta',
                          selected: _activeModel == 'Meta',
                          onTap: () => setState(() => _activeModel = 'Meta'),
                          onSend: () => _sendFromModel(
                            'Meta',
                            'Berikan tips kurasi karya ARSIVA.',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ModelButton(
                          label: 'GPT',
                          selected: _activeModel == 'GPT',
                          onTap: () => setState(() => _activeModel = 'GPT'),
                          onSend: () => _sendFromModel(
                            'GPT',
                            'Bagaimana cara analisis visual sebuah lukisan?',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ModelButton(
                          label: 'Gemini',
                          selected: _activeModel == 'Gemini',
                          onTap: () => setState(() => _activeModel = 'Gemini'),
                          onSend: () => _sendFromModel(
                            'Gemini',
                            'Saran editing artwork agar tetap natural?',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Recent Activities',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._messages.reversed
                      .take(8)
                      .map((m) => _ChatTile(message: m)),
                  if (_messages.isEmpty)
                    Text(
                      'Belum ada aktivitas. Coba tanya konsep seni atau bantuan editing karya.',
                      style: textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchComposer extends StatelessWidget {
  const _SearchComposer({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_rounded),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ask anything about art...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          IconButton(onPressed: onSubmit, icon: const Icon(Icons.send_rounded)),
        ],
      ),
    );
  }
}

class _ModelButton extends StatelessWidget {
  const _ModelButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.onSend,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withAlpha(25)
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
              height: 28,
              child: OutlinedButton(
                onPressed: onSend,
                child: const Text('Chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '${message.model} • ${message.role == 'assistant' ? 'ARSIVA AI' : 'You'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(message.text, style: Theme.of(context).textTheme.bodyMedium),
        ],
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
