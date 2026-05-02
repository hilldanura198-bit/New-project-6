class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.bio,
    required this.avatarUrl,
  });

  final String id;
  final String email;
  final String username;
  final String bio;
  final String? avatarUrl;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: (map['id'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      bio: (map['bio'] ?? '').toString(),
      avatarUrl: map['avatar_url']?.toString(),
    );
  }

  UserProfile copyWith({
    String? username,
    String? bio,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      email: email,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
