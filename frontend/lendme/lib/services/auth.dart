import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/exceptions/map.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<String?> get uid {
    return _auth.authStateChanges().map((user) => user?.uid);
  }

  // sign in anonymously
  Future<String?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user?.uid;
    } catch (e) {
      throw mapToDomainException(e);
    }
  }

  // sign in with google
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      return user?.uid;
    } catch (e) {
      throw mapToDomainException(e);
    }
  }

  // sign in with Facebook
  Future<String?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;
      return user?.uid;
    } catch (e) {
      throw mapToDomainException(e);
    }
  }

  // register with email & password
  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user?.uid;
    } catch (e) {
      throw mapToDomainException(e);
    }
  }

  // sign in with email & password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user?.uid;
    } catch (e) {
      throw mapToDomainException(e);
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw mapToDomainException(e);
    }
  }
}
