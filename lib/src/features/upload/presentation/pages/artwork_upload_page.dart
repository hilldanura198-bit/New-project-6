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
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = ref.read(userProfileProvider).value;
      if (userProfile != null) {
        _artistController.text = userProfile.username;
      }
    });
  }

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
    
    if (_pickedImage == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('data belum lengkap'),
          backgroundColor: Colors.redAccent,
        ),
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

    if (!mounted) return;

    if (ok) {
      setState(() {
        _isSuccess = true;
      });
    } else {
      final error = ref.read(artworkUploadProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Upload gagal.'))
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _yearController.clear();
    _mediumController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    setState(() {
      _pickedImage = null;
      _isSuccess = false;
    });
    final userProfile = ref.read(userProfileProvider).value;
    if (userProfile != null) {
      _artistController.text = userProfile.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(artworkUploadProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isSuccess) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, size: 80, color: Colors.green),
                ),
                const SizedBox(height: 24),
                const Text(
                  'UPLOAD SUCCESS',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                const Text(
                  'karya berhasil di upload',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Return to Home'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _resetForm,
                  child: const Text('Upload More Artworks'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Upload Artwork', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            const Text(
              'Upload Your Photos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: _pickedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text('Please upload your image', style: TextStyle(color: Colors.grey[600])),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Artwork Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            PremiumUploadField(
              controller: _titleController,
              label: 'Title',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            PremiumUploadField(
              controller: _artistController,
              label: 'Artist',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PremiumUploadField(
                    controller: _yearController,
                    label: 'Year',
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PremiumUploadField(
                    controller: _categoryController,
                    label: 'Category',
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PremiumUploadField(
              controller: _mediumController,
              label: 'Medium',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            PremiumUploadField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 3,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 30),
            if (uploadState.isUploading) ...[
              LinearProgressIndicator(
                value: uploadState.progress,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF3F51B5),
              ),
              const SizedBox(height: 8),
              Center(child: Text('${(uploadState.progress * 100).round()}% Uploading...')),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: uploadState.isUploading ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
