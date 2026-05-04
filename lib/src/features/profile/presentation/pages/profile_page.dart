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
      body: profileAsync.when(
        data: (profile) {
          final isAdmin = profile.role.toLowerCase() == 'admin';
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                                  width: 4,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                                    ? NetworkImage(profile.avatarUrl!)
                                    : null,
                                child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                                    ? const Icon(Icons.person_rounded, size: 60, color: Colors.grey)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.username,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          profile.bio.isEmpty
                              ? 'Curator of fine digital arts and cultural heritage.'
                              : profile.bio,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMenuSection(context, 'Account Settings', [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditProfilePage()),
                        ),
                      ),
                      if (isAdmin)
                        _buildMenuItem(
                          context,
                          icon: Icons.auto_awesome_motion_rounded,
                          title: 'Admin Upload Artwork',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ArtworkUploadPage()),
                          ),
                        ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildMenuSection(context, 'Preferences', [
                      _buildMenuItem(context, icon: Icons.notifications_none_rounded, title: 'Notifications'),
                      _buildMenuItem(context, icon: Icons.language_rounded, title: 'Language'),
                      _buildMenuItem(context, icon: Icons.security_rounded, title: 'Privacy & Security'),
                    ]),
                  ]),
                ),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }
}