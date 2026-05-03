import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../upload/presentation/pages/artwork_upload_page.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            final isAdmin = profile.role.toLowerCase() == 'admin';
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collector Profile',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.tune_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: Theme.of(context).brightness == Brightness.dark
                            ? const [Color(0xFF1A1A19), Color(0xFF232321)]
                            : const [Color(0xFFFFFFFF), Color(0xFFF5EFE3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x16000000),
                          blurRadius: 26,
                          offset: Offset(0, 12),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: Colors.black12,
                          backgroundImage: profile.avatarUrl != null &&
                                  profile.avatarUrl!.isNotEmpty
                              ? NetworkImage(profile.avatarUrl!)
                              : null,
                          child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                              ? const Icon(Icons.person_rounded, size: 52)
                              : null,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          profile.username,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          profile.bio.isEmpty
                              ? 'No curator note yet. Add a short biography to personalize your profile.'
                              : profile.bio,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder<void>(
                                  transitionDuration: const Duration(milliseconds: 250),
                                  pageBuilder: (context, animation, secondaryAnimation) => const EditProfilePage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded),
                            label: Text('Edit Profile', style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                        if (isAdmin) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const ArtworkUploadPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: Text(
                                'Admin Upload Artwork',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Unable to load profile: $error'),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
