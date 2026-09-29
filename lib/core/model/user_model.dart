import 'package:firebase_auth/firebase_auth.dart';

enum AuthProviderType { email, google }

class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.provider,
  });

  final String id;
  final String displayName;
  final String email;
  final AuthProviderType provider;

  factory AppUser.fromFirebaseUser(User user) {
    final isGoogle = user.providerData.any(
      (info) => info.providerId == 'google.com',
    );
    return AppUser(
      id: user.uid,
      displayName: (user.displayName != null && user.displayName!.trim().isNotEmpty)
          ? user.displayName!.trim()
          : 'NULL',
      email: (user.email != null && user.email!.trim().isNotEmpty)
          ? user.email!.trim()
          : 'NULL',
      provider: isGoogle ? AuthProviderType.google : AuthProviderType.email,
    );
  }
}