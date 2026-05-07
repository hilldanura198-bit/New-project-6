class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.phone,
    required this.bio,
    required this.avatarUrl,
    required this.role,
  });

  final String id;
  final String email;
  final String username;
  final String fullName;
  final String phone;
  final String bio;
  final String? avatarUrl;
  final String role;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: (map['id'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      fullName: (map['full_name'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      bio: (map['bio'] ?? '').toString(),
      avatarUrl: map['avatar_url']?.toString(),
      role: (map['role'] ?? 'user').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'phone': phone,
      'bio': bio,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }

  UserProfile copyWith({
    String? username,
    String? fullName,
    String? phone,
    String? bio,
    String? avatarUrl,
    String? role,
  }) {
    return UserProfile(
      id: id,
      email: email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }
}
