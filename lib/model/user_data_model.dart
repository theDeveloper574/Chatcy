class UserDataModel {
  String? name;
  String? email;
  String? password;
  String? imageUrl;
  String? about;
  String? chatId;
  String? userId;
  bool? isBlock;
  String? chatStatus;
  UserDataModel(
      {this.name,
      this.email,
      this.password,
      this.imageUrl,
      this.about,
      this.chatId,
      this.userId,
      this.isBlock,
      this.chatStatus});

  UserDataModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    password = map['password'];
    imageUrl = map['profileUrl'];
    about = map['about'];
    chatId = map['chatId'];
    userId = map['userId'];
    isBlock = map['isBlock'];
    isBlock = map['isBlock'];
    chatStatus = map['status'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "profileUrl": imageUrl,
      "about": about,
      "chatId": chatId,
      "userId": userId,
      "isBlock": isBlock,
      'status': chatStatus
    };
  }
}
