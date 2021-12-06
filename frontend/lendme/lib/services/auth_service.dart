import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/repositories/user_repository.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  // auth change user stream
  Stream<String?> get uidStream {
    return _auth.authStateChanges().map((user) => user?.uid);
  }

  String? getUid() {
    try {
      return _auth.currentUser?.uid;
    } catch (e) {
      throw UnknownException();
    }
  }

  // sign in anonymously
  Future<String?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user?.uid;
    } catch (e) {
      throw _mapAuthException(e);
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
      _userRepository.updateToken();
      return user?.uid;
    } catch (e) {
      throw _mapAuthException(e);
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
      _userRepository.updateToken();
      return user?.uid;
    } catch (e) {
      throw _mapAuthException(e);
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
      throw _mapAuthException(e);
    }
  }

  // sign in with email & password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      _userRepository.updateToken();
      return user?.uid;
    } catch (e) {
      throw _mapAuthException(e);
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw _mapAuthException(e);
    }
  }

  DomainException _mapAuthException(Object e) {
    if(e is FirebaseException) {
      switch(e.code) {
        case 'invalid-email':
          return DomainException('Provided email is invalid');
        case 'user-disabled':
          return DomainException('This user is disabled');
        case 'user-not-found':
          return DomainException('There is not user with provided email');
        case 'wrong-password':
          return DomainException('Invalid password');
        case 'account-exists-with-different-credential':
          return DomainException('Account with given credentials already exist');
        default:
          return UnknownException();
      }
    }
    else if(e is PlatformException) {
      switch(e.code) {
        case 'network_error':
          return InternetException();
        default:
          return UnknownException('Unable to authenticate');
      }
    }
    else {
      throw UnknownException();
    }
  }
}
