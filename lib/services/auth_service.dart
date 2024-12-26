import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;
  bool get isAuthenticated => _auth.currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserProfile(user.uid);
      } else {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userProfile = UserProfile.fromJson({...doc.data()!, 'uid': uid});
      } else {
        // Create new profile if it doesn't exist
        final user = _auth.currentUser!;
        _userProfile = UserProfile(
          uid: uid,
          displayName: user.displayName ?? 'Player',
          email: user.email!,
          photoUrl: user.photoURL,
        );
        await _firestore.collection('users').doc(uid).set(_userProfile!.toJson());
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<UserProfile?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _loadUserProfile(credential.user!.uid);
        return _userProfile;
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
    return null;
  }

  Future<UserProfile?> createAccountWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        
        _userProfile = UserProfile(
          uid: credential.user!.uid,
          displayName: displayName,
          email: email,
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(_userProfile!.toJson());

        notifyListeners();
        return _userProfile;
      }
    } catch (e) {
      debugPrint('Error creating account: $e');
      rethrow;
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userProfile = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      if (_userProfile == null) return;

      final updates = <String, dynamic>{};
      if (displayName != null) {
        updates['displayName'] = displayName;
        await _auth.currentUser?.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        updates['photoUrl'] = photoUrl;
        await _auth.currentUser?.updatePhotoURL(photoUrl);
      }

      if (updates.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(_userProfile!.uid)
            .update(updates);

        _userProfile = _userProfile!.copyWith(
          displayName: displayName,
          photoUrl: photoUrl,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> updateGameStats({
    required String difficulty,
    required int score,
    required Duration time,
  }) async {
    try {
      if (_userProfile == null) return;

      final highScores = Map<String, int>.from(_userProfile!.highScores);
      if (score > (highScores[difficulty] ?? 0)) {
        highScores[difficulty] = score;

        final totalScore = highScores.values.reduce((a, b) => a + b);

        await _firestore.collection('users').doc(_userProfile!.uid).update({
          'highScores': highScores,
          'totalScore': totalScore,
        });

        // Update leaderboard
        await _firestore.collection('leaderboards').doc(difficulty).set({
          'scores': FieldValue.arrayUnion([
            {
              'uid': _userProfile!.uid,
              'displayName': _userProfile!.displayName,
              'score': score,
              'time': time.inSeconds,
              'timestamp': FieldValue.serverTimestamp(),
            }
          ]),
        }, SetOptions(merge: true));

        _userProfile = _userProfile!.copyWith(
          highScores: highScores,
          totalScore: totalScore,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating game stats: $e');
    }
  }
}
