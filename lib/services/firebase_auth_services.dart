import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String userType,
    String? phoneNo,
    String? education,
    String? availability,
    String? experience,
    String? subjects,
    String? institute,
    String? year,
    String? learningFormat,
    String? preferredDays,
    String? preferredTime,
    String? resume,
  }) async {
    if (userType != 'student' && userType != 'tutor') {
      throw ArgumentError.value(userType, 'userType', 'Must be student or tutor');
    }

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase did not return a user after registration.');
    }

    final commonData = <String, Object?>{
      'uid': user.uid,
      'email': email.trim(),
      'name': name.trim(),
      'userType': userType,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final roleData = userType == 'tutor'
        ? <String, Object?>{
            ...commonData,
            'phoneNo': phoneNo,
            'education': education,
            'availability': availability,
            'experience': experience,
            'subjects': subjects,
            'resume': resume,
          }
        : <String, Object?>{
            ...commonData,
            'institute': institute,
            'year': year,
            'learningFormat': learningFormat,
            'preferredDays': preferredDays,
            'preferredTime': preferredTime,
            'resume': resume,
          };

    final batch = _firestore.batch();
    batch.set(_firestore.collection('users').doc(user.uid), commonData);
    batch.set(
      _firestore.collection(userType == 'tutor' ? 'tutors' : 'students').doc(
            user.uid,
          ),
      roleData,
    );
    await batch.commit();
    return user;
  }

  Future<void> resetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<User?> login(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final userDocument = await _firestore.collection('users').doc(uid).get();
    if (userDocument.exists) {
      return userDocument.data();
    }

    for (final collection in ['students', 'tutors']) {
      final roleDocument =
          await _firestore.collection(collection).doc(uid).get();
      if (roleDocument.exists) {
        return roleDocument.data();
      }
    }
    return null;
  }
}
