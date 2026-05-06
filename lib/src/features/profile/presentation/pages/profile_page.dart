import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../upload/presentation/pages/artwork_upload_page.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final menus = const [
          (Icons.favorite_border_rounded, 'Favourites'),
          (Icons.download_rounded, 'Downloads'),
          (Icons.language_rounded, 'Language'),
          (Icons.location_on_outlined, 'Location'),
          (Icons.workspace_premium_outlined, 'Subscription'),
          (Icons.cleaning_services_outlined, 'Clear Cache'),
          (Icons.history_rounded, 'Clear History'),
          (Icons.logout_rounded, 'Log Out'),
        ];

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                const Spacer(),
                Text('MY PROFILE', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
              ],
            ),
            const SizedBox(height: 18),
            CircleAvatar(
              radius: 44,
              backgroundImage: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty ? NetworkImage(profile.avatarUrl!) : null,
              child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty ? const Icon(Icons.person_rounded, size: 46) : null,
            ),
            const SizedBox(height: 12),
            Center(child: Text(profile.username, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
            Center(child: Text('@${profile.username.toLowerCase().replaceAll(' ', '')}', style: Theme.of(context).textTheme.bodySmall)),
            const SizedBox(height: 12),
            Center(
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE0455F)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfilePage())),
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 16),
            ...menus.map((m) => ListTile(
                  leading: Icon(m.$1),
                  title: Text(m.$2),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    if (m.$2 == 'Log Out') {
                      ref.read(userProfileProvider.notifier).logout();
                    }
                    if (m.$2 == 'Subscription') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ArtworkUploadPage()));
                    }
                  },
                )),
          ],
        );
      },
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
