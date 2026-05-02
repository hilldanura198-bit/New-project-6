import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/models/artwork_upload_draft.dart';
import '../providers/artwork_upload_provider.dart';
import '../widgets/premium_upload_field.dart';

class ArtworkUploadPage extends ConsumerStatefulWidget {
  const ArtworkUploadPage({super.key});

  @override
  ConsumerState<ArtworkUploadPage> createState() => _ArtworkUploadPageState();
}

class _ArtworkUploadPageState extends ConsumerState<ArtworkUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _yearController = TextEditingController();
  final _mediumController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _picker = ImagePicker();

  XFile? _pickedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _yearController.dispose();
    _mediumController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      maxWidth: 2200,
      imageQuality: 90,
    );

    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<void> _submit() async {
    ref.read(artworkUploadProvider.notifier).clearMessages();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an artwork image.')),
      );
      return;
    }

    final bytes = await _pickedImage!.readAsBytes();
    final ext = _pickedImage!.path.split('.').last;
    final draft = ArtworkUploadDraft(
      title: _titleController.text,
      artist: _artistController.text,
      year: _yearController.text,
      medium: _mediumController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
    );

    final ok = await ref.read(artworkUploadProvider.notifier).uploadArtwork(
          draft: draft,
          imageBytes: bytes,
          fileExt: ext,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(artworkUploadProvider);
    final message = ok
        ? (state.successMessage ?? 'Upload complete.')
        : (state.error ?? 'Upload failed.');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

    if (ok) {
      _formKey.currentState!.reset();
      _titleController.clear();
      _artistController.clear();
      _yearController.clear();
      _mediumController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      setState(() {
        _pickedImage = null;
      });
    }
  }

  String? _requiredValidator(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final uploadState = ref.watch(artworkUploadProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final profile = profileAsync.valueOrNull;
    final isAdmin = profile?.role.toLowerCase() == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Artwork')),
      body: SafeArea(
        child: !isAdmin
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 52),
                      const SizedBox(height: 12),
                      Text(
                        'Admin access required to upload artworks.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              )
            : Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF1A1A19), Color(0xFF242321)]
                        : const [Color(0xFFFFFFFF), Color(0xFFF4EEDC)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x15000000),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Artwork Preview', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: _pickedImage == null
                              ? const ColoredBox(
                                  color: Color(0xFFEFE9DE),
                                  child: Center(child: Icon(Icons.image_outlined, size: 50)),
                                )
                              : Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: uploadState.isUploading
                                  ? null
                                  : () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: const Text('Camera'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: uploadState.isUploading
                                  ? null
                                  : () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Gallery'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              PremiumUploadField(
                controller: _titleController,
                label: 'Title',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 10),
              PremiumUploadField(
                controller: _artistController,
                label: 'Artist',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 10),
              PremiumUploadField(
                controller: _yearController,
                label: 'Year',
                keyboardType: TextInputType.number,
                validator: (value) {
                  final required = _requiredValidator(value);
                  if (required != null) {
                    return required;
                  }
                  final parsed = int.tryParse((value ?? '').trim());
                  if (parsed == null || parsed < 1000 || parsed > 3000) {
                    return 'Invalid year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              PremiumUploadField(
                controller: _mediumController,
                label: 'Medium',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 10),
              PremiumUploadField(
                controller: _categoryController,
                label: 'Category',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 10),
              PremiumUploadField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 4,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: uploadState.isUploading
                    ? Column(
                        key: const ValueKey<String>('progress'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(value: uploadState.progress),
                          const SizedBox(height: 8),
                          Text(
                            'Uploading ${(uploadState.progress * 100).round()}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey<String>('idle')),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: uploadState.isUploading ? null : _submit,
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Upload Artwork'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
