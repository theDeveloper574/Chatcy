import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelContacts {
  String? name;
  String? email;
  String? password;
  String? imageUrl;
  String? about;
  String? chatId;
  String? userId;
  bool? isBlock;
  String? status;

  UserModelContacts(
      {required this.name,
      required this.email,
      required this.password,
      required this.imageUrl,
      required this.about,
      required this.chatId,
      required this.userId,
      required this.isBlock,
      required this.status});

  factory UserModelContacts.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    // dynamic data = doc.data();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModelContacts(
        name: data['name'] ?? "",
        email: data['email'] ?? "",
        password: data['password'] ?? "",
        imageUrl: data['profileUrl'] ?? "",
        about: data['about'] ?? "",
        chatId: data['chatId'] ?? "",
        userId: data['userId'] ?? "",
        isBlock: data['isBlock'] ?? "",
        status: data['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'profileUrl': imageUrl,
      'about': about,
      'chatId': chatId,
      'userId': userId,
      'isBlock': isBlock,
      'status': status
    };
  }
}
