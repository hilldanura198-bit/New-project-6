import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  XFile? _avatar;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 88,
    );
    if (file != null) setState(() => _avatar = file);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(userProfileProvider.notifier);
    if (_avatar != null) {
      final bytes = await _avatar!.readAsBytes();
      final ext = _avatar!.path.split('.').last;
      await notifier.uploadAvatar(bytes: bytes, fileExt: ext);
    }
    await notifier.saveProfile(
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile berhasil diperbarui.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    if (profile != null && _usernameController.text.isEmpty) {
      _nameController.text = (profile.username);
      _emailController.text = profile.email;
      _usernameController.text = profile.username;
      _bioController.text = profile.bio;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PROFILE'),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.check_rounded)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: _avatar != null
                        ? FileImage(File(_avatar!.path))
                        : (profile?.avatarUrl != null &&
                                      profile!.avatarUrl!.isNotEmpty
                                  ? NetworkImage(profile.avatarUrl!)
                                  : null)
                              as ImageProvider?,
                    child:
                        (_avatar == null &&
                            (profile?.avatarUrl == null ||
                                profile!.avatarUrl!.isEmpty))
                        ? const Icon(Icons.person_rounded, size: 42)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1657C0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _field('Name', _nameController),
            _field('E mail address', _emailController),
            _field('User name', _usernameController),
            _field('Password', _passwordController, obscure: true),
            _field('Phone number', _phoneController),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            controller: c,
            obscureText: obscure,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
        ],
      ),
    );
  }
}
