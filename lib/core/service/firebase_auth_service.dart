import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth;

  FirebaseAuth? _auth;

  FirebaseAuth get auth => _auth ??= FirebaseAuth.instance;
}
