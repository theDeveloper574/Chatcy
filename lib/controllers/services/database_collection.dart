import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

///firebase storage profile storage
firebase_storage.Reference profileImgRef = firebase_storage
    .FirebaseStorage.instance
    .ref('profileImage')
    .child(FirebaseAuth.instance.currentUser!.uid.toString());

///firebase storage change profile image
firebase_storage.Reference changeProfileImgRef = firebase_storage
    .FirebaseStorage.instance
    .ref('newProfileImage')
    .child(FirebaseAuth.instance.currentUser!.uid.toString());

///current user doc id
final docId = FirebaseAuth.instance.currentUser!.uid;

///database collection for user profile
final userDatabase = FirebaseFirestore.instance.collection('usersProfile');

///database collection chat screen
final chatImage = FirebaseFirestore.instance.collection('usersProfile');
