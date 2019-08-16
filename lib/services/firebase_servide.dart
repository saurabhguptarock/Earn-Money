import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> signIn(String email, String password) async {
  FirebaseUser user =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  return user;
}

Future<FirebaseUser> signUp(
    String name, String email, String password1, String password2) async {
  var data = {'email': email, 'name': name};
  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
  FirebaseUser users = await _auth
      .createUserWithEmailAndPassword(email: email, password: password1)
      .then((FirebaseUser user) {
    userUpdateInfo.displayName = name;
    Firestore.instance.collection("usersdetail").add(data).then((v) {
      userUpdateInfo.photoUrl = v.documentID;
    });
    user.updateProfile(userUpdateInfo);
    user.sendEmailVerification();
  }).catchError((e) {
    print(e);
  });
  return users;
}

void signOut() {
  _auth.signOut();
}

Future<void> resetPass(String email) async {
  return _auth.sendPasswordResetEmail(email: email);
}

Future<DocumentReference> sendMessage(
    String email, String name, String message) {
  var data = {'email': email, 'name': name, 'message': message};
  return Firestore.instance.collection('contactmessages').add(data);
}

Future<FirebaseUser> updatePassword(String newpass) async {
  return _auth.currentUser().then((user) {
    user.updatePassword(newpass);
  });
}

Future<void> updateDetails(String name, String email, String docId) async {
  var data = {'name': name, 'email': email};
  return Firestore.instance.collection('path').document(docId).updateData(data);
}

Future<void> updateEmail(String email) async {
  return FirebaseAuth.instance.currentUser().then((user) {
    user.updateEmail(email);
    user.sendEmailVerification();
  });
}
