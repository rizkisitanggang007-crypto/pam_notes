import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  static bool _googleReady = false;

  // Web client ID dibaca dari --dart-define agar tidak ter-hardcode:
  // flutter run --dart-define=WEB_CLIENT_ID=xxxx.apps.googleusercontent.com
  static const _webClientId = String.fromEnvironment('WEB_CLIENT_ID');

  Stream<User?> get authState => _auth.authStateChanges();

  Future<void> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signInWithGoogle() async {
    final google = GoogleSignIn.instance;
    if (!_googleReady) {
      await google.initialize(serverClientId: _webClientId);
      _googleReady = true;
    }
    final account = await google.authenticate();
    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _auth.signInWithCredential(credential);
  }

  Future<void> logout() => _auth.signOut();
}
